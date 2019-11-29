

resource "random_id" "postfix" {
  byte_length = 4
}

resource "alicloud_fc_service" "default" {
  name        = "mk-function-service"
  description = "tf unit test"

}

data "archive_file" "source" {
  type        = "zip"
  source_file = "${path.module}/src/index.py"
  output_path = "${path.module}/dist/alicloud-test-${random_id.postfix.b64_url}.zip"
}

resource "alicloud_fc_function" "fc_function" {
  service  = alicloud_fc_service.default.name
  name     = "mk-test-function"
  filename = "./dist/alicloud-test-${random_id.postfix.b64_url}.zip"
  runtime  = "python3"
  handler  = "index.handler"
}

resource "alicloud_fc_trigger" "fc_trigger" {
  service  = alicloud_fc_service.default.name
  function = alicloud_fc_function.fc_function.name
  name     = "mk-test-http-trigger"
  type     = "http"
  config   = "{ \"methods\": [\"GET\"], \"authType\": \"anonymous\" }"
}



output "connection" {
  value = [alicloud_fc_trigger.fc_trigger.trigger_id]
}
