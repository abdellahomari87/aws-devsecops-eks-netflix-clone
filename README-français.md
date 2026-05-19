# ☁️ AWS DevSecOps EKS Netflix Clone

## 📌 Description

Ce repository contient toute l’infrastructure cloud, l’automatisation DevSecOps, la pipeline CI/CD, le monitoring et les intégrations de sécurité AWS utilisées pour déployer et sécuriser l’application Netflix Clone sur AWS.

Le projet a été conçu afin de moderniser un déploiement applicatif classique vers une plateforme DevSecOps proche d’un environnement production, en utilisant l’Infrastructure as Code, Kubernetes, l’automatisation cloud et les bonnes pratiques de sécurité.

---

# 🎯 Objectifs du Projet

- Automatiser le provisionnement de l’infrastructure AWS
- Déployer des applications de manière sécurisée sur Amazon EKS
- Implémenter une pipeline CI/CD complète
- Appliquer les pratiques DevSecOps et Shift-Left Security
- Intégrer les services de sécurité AWS
- Mettre en place la sécurité runtime Kubernetes
- Construire une architecture cloud proche d’un environnement production
- Réduire au maximum les opérations manuelles dans la console AWS

---

# 🏗️ Vue d’Ensemble de l’Architecture

## ☁️ Plateforme Cloud

- AWS

## ☸️ Orchestration de Conteneurs

- Amazon EKS
- Kubernetes

## ⚙️ Infrastructure as Code

- Terraform

## 🤖 Automatisation & Configuration

- Ansible
- Jenkins Configuration as Code (JCasC)

## 🚀 CI/CD

- Jenkins
- Docker
- DockerHub

## 📊 Monitoring

- Prometheus
- Grafana
- Node Exporter

## 🔐 Sécurité

### Sécurité AWS

- AWS GuardDuty
- AWS Security Hub
- AWS Config
- AWS CloudTrail
- IAM Least Privilege
- IMDSv2 activé
- Chiffrement EBS
- VPC Flow Logs

### Sécurité DevSecOps

- Trivy
- OWASP Dependency Check
- SonarQube

### Sécurité Kubernetes

- NetworkPolicy
- Hardening des Pods
- Bonnes pratiques de sécurité runtime

---

# 🚀 Automatisation de l’Infrastructure

L’infrastructure est entièrement provisionnée avec Terraform.

## Composants Terraform

- VPC
- Subnets
- Security Groups
- Instances EC2
- IAM Roles & Policies
- Amazon EKS
- Secrets Manager
- Infrastructure de monitoring

---

# 🤖 Automatisation Ansible

Ansible est utilisé pour automatiser :

- Installation Jenkins
- Installation Docker
- Configuration monitoring
- Installation SonarQube
- Configuration Prometheus & Grafana
- Jenkins Configuration as Code (JCasC)
- Configuration sécurité

---

# ⚙️ Jenkins & CI/CD

La pipeline Jenkins automatise :

- Build de l’application
- Analyse statique du code
- Scan sécurité
- Build des images Docker
- Push des images Docker
- Déploiement Kubernetes
- Validation automatique des contrôles sécurité

---

# 🔐 Gestion Sécurisée des Secrets

Les secrets sont stockés de manière sécurisée avec AWS Secrets Manager.

## Secrets gérés

- Credentials DockerHub
- Tokens SonarQube
- API Keys
- Credentials Jenkins
- Credentials Grafana
- Secrets Webhook

## Fonctionnalités de sécurité

- Création des secrets avec Terraform
- Accès basé sur IAM Roles
- Injection runtime des secrets
- Aucun secret exposé dans Git

---

# ☸️ Sécurité Kubernetes

Le projet applique plusieurs bonnes pratiques Kubernetes Security :

- runAsNonRoot
- readOnlyRootFilesystem
- allowPrivilegeEscalation: false
- seccompProfile: RuntimeDefault
- Liveness & Readiness probes
- Isolation NetworkPolicy

---

# 🌐 Kubernetes Network Policies

Des tests automatisés valident :

- Le trafic autorisé
- Le trafic bloqué
- La résolution DNS
- L’isolation des Pods
- La communication sécurisée entre namespaces

---

# 📊 Stack de Monitoring

## Prometheus

Utilisé pour collecter :

- Métriques Jenkins
- Métriques Kubernetes
- Métriques EC2
- Métriques système

## Grafana

Utilisé pour :

- Dashboards
- Visualisation infrastructure
- Alertes monitoring

---

# 📂 Structure du Repository

terraform/
ansible/
monitoring/

Jenkinsfile
README-english.md
README-français.md

Repository Associé

Repository contenant le code source de l’application :

👉 https://github.com/abdellahomari87/Netflix-clone-abdellah
