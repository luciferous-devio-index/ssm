terraform {
  cloud {
    organization = "luciferous-devio-index"
    workspaces {
      name = "ssm"
    }
  }


  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "=4.63.0"
    }
  }
  required_version = "=1.4.5"
}

variable "OPEN_AI_API_KEY" {}
variable "SLACK_INCOMING_WEBHOOK" {}

resource "aws_kms_key" "encrypt" {}
resource "aws_kms_alias" "encrypt" {
  target_key_id = aws_kms_key.encrypt.id
  name          = "alias/luciferous-devio-index"
}

resource "aws_ssm_parameter" "open_ai_api_key" {
  name   = "/LuciferousDevIoIndex/Secrets/OpenAiApiKey"
  type   = "SecureString"
  key_id = aws_kms_alias.encrypt.arn
  overwrite = true
  value  = var.OPEN_AI_API_KEY
}

resource "aws_ssm_parameter" "slack_incoming_webhook" {
  name   = "/LuciferousDevIoIndex/Secrets/SlackIncomingWebhook"
  type   = "SecureString"
  key_id = aws_kms_alias.encrypt.arn
  overwrite = true
  value  = var.SLACK_INCOMING_WEBHOOK
}
