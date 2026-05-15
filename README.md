🎬 Netflix Clone – Full DevSecOps Pipeline on AWS
Ce projet démontre une implémentation "End-to-End" d'une architecture sécurisée sur AWS, intégrant la sécurité dès la phase de build (Shift Left) jusqu'au runtime Kubernetes.

🏗️ Stack Technique
Cloud : AWS (EKS, IAM, Secrets Manager, GuardDuty)

IaC : Terraform (Modularisé)

CI/CD : Jenkins (Pipeline-as-Code)

Sécurité : Trivy, OWASP, SonarQube, AWS Security Hub

Monitoring : Prometheus & Grafana

🛡️ Points Clés de Sécurité (DevSecOps)
Zéro Secret dans Git : Utilisation d'AWS Secrets Manager avec injection via IAM Roles.

Sécurité Conteneur : Scan d'images avec Trivy et durcissement des Pods (Non-root, Read-only FS).

Sécurité Réseau : Implémentation de NetworkPolicies K8s avec tests automatisés dans la pipeline.

Audit & Conformité : Activation de CloudTrail, AWS Config et GuardDuty.
