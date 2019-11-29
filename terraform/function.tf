

resource "random_id" "postfix" {
  byte_length = 4
}

resource "alicloud_fc_service" "default" {
  name        = "mk-function-service"
  description = "tf unit test"
  log_config {
    logstore = "mk-log"
    project = "mk-log"

  }

  /*
  {
    "Statement": [
        {
            "Action": "sts:AssumeRole",
            "Effect": "Allow",
            "Principal": {
                "Service": [
                    "ecs.aliyuncs.com",
                    "fc.aliyuncs.com"
                ]
            }
        }
    ],
    "Version": "1"
}
  */
  role = "acs:ram::5387055494048711:role/mk-test-role"



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
  config     = <<EOF
    {

		"methods": ["GET"],
		"authType": "anonymous",
        "sourceConfig": {
            "project": "project-for-fc",
            "logstore": "project-for-fc"
        },
        "jobConfig": {
            "maxRetryTime": 3,
            "triggerInterval": 60
        },
        "functionParameter": {
            "a": "b",
            "c": "d"
        },
        "logConfig": {
            "project": "project-for-fc",
            "logstore": "project-for-fc"
        },
        "enable": true
    }
  EOF
}



output "trigger_id" {
  value = [alicloud_fc_trigger.fc_trigger.trigger_id]
}
