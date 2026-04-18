# 🎬 Netflix Clone – DevSecOps Project (AWS + EKS + CI/CD + Security)

## 📌 Description

Ce projet met en œuvre une architecture **DevSecOps complète et sécurisée** pour le déploiement d’une application type Netflix sur AWS, avec :

* Infrastructure as Code (Terraform)
* CI/CD automatisé (Jenkins)
* Sécurité intégrée (AWS + Kubernetes)
* Gestion sécurisée des secrets (AWS Secrets Manager)
* Monitoring et validation de sécurité automatisée

---

## 🏗️ Architecture

* **Cloud** : AWS
* **Orchestration** : Amazon EKS (Kubernetes)
* **CI/CD** : Jenkins
* **IaC** : Terraform
* **Configuration** : Ansible
* **Containerisation** : Docker
* **Monitoring** : Prometheus + Grafana
* **Gestion des secrets** : AWS Secrets Manager
* **Sécurité** :

  * AWS GuardDuty
  * AWS Security Hub
  * AWS Config
  * AWS CloudTrail
  * Trivy (scan images)
  * OWASP Dependency Check
  * SonarQube (analyse statique)

---

## ⚙️ Fonctionnalités principales

### 🚀 CI/CD Pipeline

* Build de l’application
* Analyse de code (SonarQube)
* Scan sécurité (Trivy, OWASP)
* Build & push Docker image
* Déploiement automatique sur EKS
* Tests de sécurité réseau automatisés (NetworkPolicy)

---

### 🔐 Gestion sécurisée des secrets

* Tous les secrets sont stockés dans **AWS Secrets Manager**
* Création des secrets via **Terraform**
* Accès aux secrets via **IAM Role attaché à l’instance Jenkins**
* Lecture des secrets dans **Ansible (runtime)** → aucune exposition dans Git
* Exemples de secrets gérés :

  * DockerHub Token
  * API keys (NVD, TMDB)
  * Mots de passe Jenkins / SonarQube / Grafana
  * Webhook secret SonarQube

---

### 🔐 Sécurité AWS

* IMDSv2 activé
* Volumes EBS chiffrés
* VPC Flow Logs
* GuardDuty activé
* Security Hub (AWS Best Practices)
* CloudTrail (audit des appels API)
* AWS Config (compliance tracking)

---

### ☸️ Sécurité Kubernetes

* Pods exécutés en non-root (`runAsNonRoot`)
* `readOnlyRootFilesystem: true`
* `allowPrivilegeEscalation: false`
* `seccompProfile: RuntimeDefault`
* Limitation CPU/Mémoire
* Health checks (`livenessProbe`, `readinessProbe`)

---

### 🌐 Sécurité réseau Kubernetes

* Implémentation de **NetworkPolicy**
* Tests automatisés dans la pipeline Jenkins :

  * Client autorisé → accès OK
  * Client bloqué → accès refusé
* Validation via `curl` et `nslookup`

---

## 📊 Monitoring

* Prometheus pour la collecte des métriques
* Grafana pour la visualisation
* Métriques collectées :

  * Jenkins
  * Node Exporter (EC2)
  * Infrastructure système

---

## 🧪 Tests de sécurité automatisés

Le pipeline Jenkins valide automatiquement :

* Connectivité réseau autorisée
* Blocage du trafic non autorisé
* Résolution DNS contrôlée

---

## 📂 Structure du projet

```id="fr-struct"
terraform/           # Infrastructure AWS + Secrets Manager
ansible/             # Configuration Jenkins / Prometheus / Grafana
Kubernetes/
  deployment.yml
  service.yml
  networkpolicy.yml
  tests/
    network-policy/
Dockerfile
Jenkinsfile
```

---

## 🎯 Objectif

Ce projet démontre une implémentation complète DevSecOps avec :

* Sécurité intégrée dès le build (Shift Left)
* Sécurité runtime (Kubernetes)
* Gestion sécurisée des secrets (Secrets Manager)
* Observabilité et audit AWS
* Automatisation complète CI/CD

---

## 📈 Résultat

* Application déployée sur EKS
* Pipeline CI/CD entièrement automatisé
* Sécurité validée automatiquement
* Architecture proche d’un environnement production

---

## 👨‍💻 Auteur

Projet réalisé dans une démarche avancée DevSecOps et Cloud Security.