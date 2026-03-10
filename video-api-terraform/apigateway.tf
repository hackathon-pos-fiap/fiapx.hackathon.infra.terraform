locals {
  eks_service_hostname = try(kubernetes_service.app.status[0].load_balancer[0].ingress[0].hostname, null)
  eks_service_ip       = try(kubernetes_service.app.status[0].load_balancer[0].ingress[0].ip, null)
  eks_service_endpoint = local.eks_service_hostname != null ? local.eks_service_hostname : local.eks_service_ip
}

resource "aws_apigatewayv2_integration" "eks_api_integration" {
  api_id                 = data.terraform_remote_state.lambda.outputs.api_gateway_auth_api_id
  integration_type       = "HTTP_PROXY"
  integration_method     = "ANY"
  integration_uri        = "http://${local.eks_service_endpoint}"
  payload_format_version = "1.0"
  timeout_milliseconds   = 29000
  request_parameters = {
    "overwrite:path" = "$request.path"
  }
}

resource "aws_apigatewayv2_route" "autorize_video_route" {
  api_id             = data.terraform_remote_state.lambda.outputs.api_gateway_auth_api_id
  route_key          = "ANY /video"
  target             = "integrations/${aws_apigatewayv2_integration.eks_api_integration.id}"
  authorization_type = "JWT"
  authorizer_id      = data.terraform_remote_state.lambda.outputs.cognito_authorizer_id
}

resource "aws_apigatewayv2_route" "autorize_get_video_id_route" {
  api_id             = data.terraform_remote_state.lambda.outputs.api_gateway_auth_api_id
  route_key          = "ANY /video/{id}"
  target             = "integrations/${aws_apigatewayv2_integration.eks_api_integration.id}"
  authorization_type = "JWT"
  authorizer_id      = data.terraform_remote_state.lambda.outputs.cognito_authorizer_id
}

resource "aws_apigatewayv2_route" "autorize_set_status_video_route" {
  api_id             = data.terraform_remote_state.lambda.outputs.api_gateway_auth_api_id
  route_key          = "ANY /video/{id}/status"
  target             = "integrations/${aws_apigatewayv2_integration.eks_api_integration.id}"
  authorization_type = "JWT"
  authorizer_id      = data.terraform_remote_state.lambda.outputs.cognito_authorizer_id
}