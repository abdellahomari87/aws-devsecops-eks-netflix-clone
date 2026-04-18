output "cicd_public_ip" {
  value = aws_instance.cicd.public_ip
}

output "monitoring_public_ip" {
  value = aws_instance.monitoring.public_ip
}

output "cicd_jenkins_url" {
  value = "http://${aws_instance.cicd.public_ip}:8080"
}

output "cicd_sonarqube_url" {
  value = "http://${aws_instance.cicd.public_ip}:9000"
}

output "monitoring_prometheus_url" {
  value = "http://${aws_instance.monitoring.public_ip}:9090"
}

output "monitoring_grafana_url" {
  value = "http://${aws_instance.monitoring.public_ip}:3000"
}

output "secrets_names" {
  value = {
    jenkins_admin_password   = aws_secretsmanager_secret.jenkins_admin_password.name
    sonarqube_admin_password = aws_secretsmanager_secret.sonarqube_admin_password.name
    grafana_admin_password   = aws_secretsmanager_secret.grafana_admin_password.name
    dockerhub                = aws_secretsmanager_secret.dockerhub.name
    nvd_api_key              = aws_secretsmanager_secret.nvd_api_key.name
    tmdb_api_key             = aws_secretsmanager_secret.tmdb_api_key.name
    webhook_secret           = aws_secretsmanager_secret.sonarqube_webhook_secret.name
  }
}