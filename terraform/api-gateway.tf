# ---------------
# API Gateway
# ---------------
/*
resource "alicloud_api_gateway_group" "apigw-group" {
  name = "TestApiGatewayGroup"
  description = "API Gateway group deployed through Terraform"
}

resource "alicloud_api_gateway_api" "apigw-api-test" {
  depends_on = [
    alicloud_ram_role_policy_attachment.apigw-fc-access-role-attachment
  ]

  name = "TestEndpoint"
  group_id = alicloud_api_gateway_group.apigw-group.id
  description = "Test endpoint for API Gateway"
  auth_type = "ANONYMOUS"

  request_config {
    protocol = "HTTP"
    method = "GET"
    path = "/test"
    mode = "PASSTHROUGH"
  }

  service_type = "FunctionCompute"

  fc_service_config {
    function_name = alicloud_fc_function.apigw-fc-test.name
    service_name = alicloud_fc_service.apigw-fc-service.name
    arn_role = alicloud_ram_role.apigw-fc-access-role.arn
    region = var.region
    timeout = 5000
  }

  stage_names = [
    "PRE",
    "RELEASE",
    "TEST"
  ]
}


*/