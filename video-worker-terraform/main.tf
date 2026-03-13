provider "aws" {
  region = "us-east-1"
}

# Busca outputs do infra-base (EKS)
data "terraform_remote_state" "base" {
  backend = "s3"
  config = {
    bucket = "fiapx-terraform-state-lgrando"
    key    = "eks/terraform.tfstate"
    region = "us-east-1"
  }
}

# Busca outputs do infra-database 
data "terraform_remote_state" "database" {
  backend = "s3"
  config = {
    bucket = "fiapx-terraform-state-lgrando"
    key    = "atlas/terraform.tfstate"
    region = "us-east-1"
  }
}

# Busca outputs do infra-lambda (API Gateway e Cognito)
data "terraform_remote_state" "lambda" {
  backend = "s3"
  config = {
    bucket = "fiapx-terraform-state-lgrando"
    key    = "auth/terraform.tfstate"
    region = "us-east-1"
  }
}

# Autenticação no EKS
data "aws_eks_cluster" "cluster" {
  name = data.terraform_remote_state.base.outputs.cluster_name
}

data "aws_eks_cluster_auth" "cluster" {
  name = data.terraform_remote_state.base.outputs.cluster_name
}

# Provider Kubernetes apontando pro cluster EKS
provider "kubernetes" {
  host                   = data.aws_eks_cluster.cluster.endpoint
  cluster_ca_certificate = base64decode(data.aws_eks_cluster.cluster.certificate_authority[0].data)
  token                  = data.aws_eks_cluster_auth.cluster.token
}

# ConfigMap com variáveis da aplicação
resource "kubernetes_config_map" "app_config" {
  metadata {
    name = "${var.app_name}-config"
  }
  data = {
    GATEWAY_API_URL = "${data.terraform_remote_state.lambda.outputs.api_gateway_url}"
    BUCKET_ACCESS_KEY_ID = "${var.bucket_access_key_id}"
    BUCKET_SECRET_KEY    = "${var.bucket_secret_key}"
    ASPNETCORE_ENVIRONMENT = "Development"
    queueUrl = "${data.terraform_remote_state.database.outputs.sqs_worker_queue_url}"
    BucketName = "fiapx-video-worker-lgrando"
    SES_SOURCE_EMAIL = "zeliasgl@gmail.com"
  }
}


# Deployment da API
resource "kubernetes_deployment" "app" {
  metadata {
    name = var.app_name
    labels = {
      app = var.app_name
    }
  }

  spec {
    replicas = var.replicas

    selector {
      match_labels = {
        app = var.app_name
      }
    }

    template {
      metadata {
        labels = {
          app = var.app_name
        }
      }

      spec {
        container {
          name  = var.app_name
          image = var.docker_image

          env_from {
            config_map_ref {
              name = kubernetes_config_map.app_config.metadata[0].name
            }
          }

          resources {
            requests = {
              memory = "64Mi"
              cpu    = "50m"
            }
            limits = {
              memory = "128Mi"
              cpu    = "100m"
            }
          }
        }
      }
    }
  }
}

# Horizontal Pod Autoscaler
resource "kubernetes_horizontal_pod_autoscaler_v2" "app_hpa" {
  metadata {
    name = "${var.app_name}-hpa"
  }

  spec {
    scale_target_ref {
      api_version = "apps/v1"
      kind        = "Deployment"
      name        = kubernetes_deployment.app.metadata[0].name
    }

    min_replicas = 2
    max_replicas = 3

    metric {
      type = "Resource"
      resource {
        name = "cpu"
        target {
          type                = "Utilization"
          average_utilization = 40
        }
      }
    }
  }
}