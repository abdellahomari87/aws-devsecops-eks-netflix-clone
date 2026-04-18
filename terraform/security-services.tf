############################################
# GuardDuty
############################################

resource "aws_guardduty_detector" "this" {
  enable = true

  tags = {
    Name    = "${var.project}-guardduty"
    Project = var.project
  }
}

############################################
# Security Hub
############################################

resource "aws_securityhub_account" "this" {
  enable_default_standards = false
}

resource "aws_securityhub_standards_subscription" "fsbp" {
  depends_on = [
    aws_securityhub_account.this,
    aws_config_configuration_recorder.this,
    aws_config_delivery_channel.this,
    aws_config_configuration_recorder_status.this
  ]

  standards_arn = "arn:aws:securityhub:${var.region}::standards/aws-foundational-security-best-practices/v/1.0.0"

  timeouts {
    create = "60m"
    delete = "40m"
  }
}