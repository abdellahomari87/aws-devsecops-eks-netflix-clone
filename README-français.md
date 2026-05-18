# 🎬 Netflix Clone – Plateforme DevSecOps Complète sur AWS

## 📌 Description

Ce projet met en œuvre une plateforme DevSecOps complète et sécurisée pour le déploiement d’une application type Netflix sur AWS.

Le projet original reposait principalement sur des opérations manuelles dans la console AWS.  
Cette version a été entièrement réarchitecturée afin d’appliquer une approche moderne :

- Infrastructure as Code
- Automation First
- Security by Design
- CI/CD sécurisé
- Kubernetes Security
- Observabilité & conformité AWS

L’objectif principal était de réduire au maximum les opérations manuelles et de rendre toute l’infrastructure reproductible, sécurisée et automatisée.

---

# 🚀 Industrialisation & Automatisation du Projet

## ✅ Améliorations apportées

- Infrastructure AWS entièrement provisionnée avec Terraform
- Configuration automatisée avec Ansible
- Jenkins entièrement configuré via JCasC (Jenkins Configuration as Code)
- Réduction maximale des clics manuels dans AWS
- Déploiement Kubernetes automatisé sur Amazon EKS
- Gestion centralisée des secrets avec AWS Secrets Manager
- Pipeline CI/CD entièrement automatisé
- Sécurité intégrée dès la phase de build (DevSecOps / Shift Left)
- Validation automatique des politiques réseau Kubernetes
- Architecture reproductible proche d’un environnement production réel

---

# 🏗️ Architecture

## ☁️ Cloud & Infrastructure

- AWS
- Amazon EKS (Kubernetes)
- EC2
- IAM
- VPC
- Security Groups
- EBS Encryption
- VPC Flow Logs

## ⚙️ Infrastructure as Code & Automation

- Terraform
- Ansible
- Jenkins Configuration as Code (JCasC)

## 🚀 CI/CD & Containerisation

- Jenkins
- Docker
- DockerHub
- Kubernetes

## 📊 Monitoring & Observabilité

- Prometheus
- Grafana
- Node Exporter

## 🔐 Sécurité & Conformité

### Sécurité AWS

- AWS GuardDuty
- AWS Security Hub
- AWS Config
- AWS CloudTrail
- IAM Least Privilege
- IMDSv2 activé
- Chiffrement EBS

### Sécurité DevSecOps

- Trivy
- OWASP Dependency Check
- SonarQube

### Sécurité Kubernetes

- NetworkPolicy
- runAsNonRoot
- readOnlyRootFilesystem
- allowPrivilegeEscalation: false
- seccompProfile: RuntimeDefault
- CPU & Memory Limits
- Liveness & Readiness Probes

---

# ⚙️ Fonctionnalités Principales

## 🚀 Pipeline CI/CD

Le pipeline Jenkins automatise :

- Build de l’application
- Analyse statique avec SonarQube
- Scan sécurité avec Trivy
- Scan dépendances OWASP
- Build Docker
- Push Docker image
- Déploiement automatique sur EKS
- Validation automatique des politiques réseau Kubernetes

---

# 🔐 Gestion Sécurisée des Secrets

Tous les secrets sont stockés dans AWS Secrets Manager.

## ✅ Secrets gérés

- DockerHub Token
- API Keys
- Jenkins Password
- SonarQube Password
- Grafana Password
- SonarQube Webhook Secret

## ✅ Sécurité mise en place

- Création des secrets via Terraform
- Lecture dynamique via IAM Roles
- Aucune exposition des secrets dans Git
- Injection runtime avec Ansible

---

# ☸️ Sécurité Kubernetes

## ✅ Hardening des Pods

- Exécution non-root
- Système de fichiers en lecture seule
- Désactivation de l’élévation de privilèges
- Profil seccomp RuntimeDefault
- Limitation des ressources CPU/Mémoire

## ✅ Validation des politiques réseau

Des tests automatisés valident :

- Le trafic autorisé
- Le trafic bloqué
- La résolution DNS
- L’isolation réseau Kubernetes

---

# 📊 Monitoring

## Prometheus

Collecte des métriques :

- Jenkins
- Instances EC2
- Infrastructure système
- Kubernetes

## Grafana

Visualisation des métriques et dashboards.
