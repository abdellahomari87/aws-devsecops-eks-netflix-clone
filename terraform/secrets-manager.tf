############################################
# Variables
############################################

variable "dockerhub_username" {
  type = string
}

variable "dockerhub_token" {
  type      = string
  sensitive = true
}

variable "jenkins_admin_password" {
  type      = string
  sensitive = true
}

variable "sonarqube_admin_password" {
  type      = string
  sensitive = true
}

variable "grafana_admin_password" {
  type      = string
  sensitive = true
}

variable "nvd_api_key" {
  type      = string
  sensitive = true
}

variable "tmdb_api_key" {
  type      = string
  sensitive = true
}

variable "sonarqube_webhook_secret" {
  type      = string
  sensitive = true
}

locals {
  secrets_prefix = var.project
}

############################################
# Secrets Manager secrets
############################################

resource "aws_secretsmanager_secret" "jenkins_admin_password" {
  name                    = "${local.secrets_prefix}/jenkins/admin_password"
  recovery_window_in_days = 0
  tags = {
    Project = var.project
  }
}

resource "aws_secretsmanager_secret_version" "jenkins_admin_password" {
  secret_id     = aws_secretsmanager_secret.jenkins_admin_password.id
  secret_string = var.jenkins_admin_password
}

resource "aws_secretsmanager_secret" "sonarqube_admin_password" {
  name                    = "${local.secrets_prefix}/sonarqube/admin_password"
  recovery_window_in_days = 0
  tags = {
    Project = var.project
  }
}

resource "aws_secretsmanager_secret_version" "sonarqube_admin_password" {
  secret_id     = aws_secretsmanager_secret.sonarqube_admin_password.id
  secret_string = var.sonarqube_admin_password
}

resource "aws_secretsmanager_secret" "grafana_admin_password" {
  name                    = "${local.secrets_prefix}/grafana/admin_password"
  recovery_window_in_days = 0
  tags = {
    Project = var.project
  }
}

resource "aws_secretsmanager_secret_version" "grafana_admin_password" {
  secret_id     = aws_secretsmanager_secret.grafana_admin_password.id
  secret_string = var.grafana_admin_password
}

resource "aws_secretsmanager_secret" "dockerhub" {
  name                    = "${local.secrets_prefix}/dockerhub/credentials"
  recovery_window_in_days = 0
  tags = {
    Project = var.project
  }
}

resource "aws_secretsmanager_secret_version" "dockerhub" {
  secret_id = aws_secretsmanager_secret.dockerhub.id
  secret_string = jsonencode({
    username = var.dockerhub_username
    token    = var.dockerhub_token
  })
}

resource "aws_secretsmanager_secret" "nvd_api_key" {
  name                    = "${local.secrets_prefix}/nvd/api_key"
  recovery_window_in_days = 0
  tags = {
    Project = var.project
  }
}

resource "aws_secretsmanager_secret_version" "nvd_api_key" {
  secret_id     = aws_secretsmanager_secret.nvd_api_key.id
  secret_string = var.nvd_api_key
}

resource "aws_secretsmanager_secret" "tmdb_api_key" {
  name                    = "${local.secrets_prefix}/tmdb/api_key"
  recovery_window_in_days = 0
  tags = {
    Project = var.project
  }
}

resource "aws_secretsmanager_secret_version" "tmdb_api_key" {
  secret_id     = aws_secretsmanager_secret.tmdb_api_key.id
  secret_string = var.tmdb_api_key
}

resource "aws_secretsmanager_secret" "sonarqube_webhook_secret" {
  name                    = "${local.secrets_prefix}/sonarqube/webhook_secret"
  recovery_window_in_days = 0
  tags = {
    Project = var.project
  }
}

resource "aws_secretsmanager_secret_version" "sonarqube_webhook_secret" {
  secret_id     = aws_secretsmanager_secret.sonarqube_webhook_secret.id
  secret_string = var.sonarqube_webhook_secret
}