# 🎬 Netflix Clone – DevSecOps Project (AWS + EKS + CI/CD + Security)

## 📌 Overview

This project implements a **fully secured DevSecOps architecture** to deploy a Netflix-like application on AWS, including:

* Infrastructure as Code (Terraform)
* Automated CI/CD (Jenkins)
* Integrated security (AWS + Kubernetes)
* Secure secrets management (AWS Secrets Manager)
* Monitoring and automated security validation

---

## 🏗️ Architecture

* **Cloud**: AWS
* **Orchestration**: Amazon EKS (Kubernetes)
* **CI/CD**: Jenkins
* **IaC**: Terraform
* **Configuration**: Ansible
* **Containerization**: Docker
* **Monitoring**: Prometheus + Grafana
* **Secrets Management**: AWS Secrets Manager
* **Security**:

  * AWS GuardDuty
  * AWS Security Hub
  * AWS Config
  * AWS CloudTrail
  * Trivy (image scanning)
  * OWASP Dependency Check
  * SonarQube (static analysis)

---

## ⚙️ Key Features

### 🚀 CI/CD Pipeline

* Application build
* Static code analysis (SonarQube)
* Security scans (Trivy, OWASP)
* Docker image build & push
* Automated deployment to EKS
* Automated NetworkPolicy validation

---

### 🔐 Secure Secrets Management

* All secrets are stored in **AWS Secrets Manager**
* Secrets created via **Terraform**
* Access controlled via **IAM Role attached to Jenkins EC2**
* Secrets retrieved dynamically in **Ansible (runtime)**
* No secrets stored in Git repository

Examples:

* DockerHub token
* API keys (NVD, TMDB)
* Jenkins / SonarQube / Grafana passwords
* SonarQube webhook secret

---

### 🔐 AWS Security

* IMDSv2 enabled
* Encrypted EBS volumes
* VPC Flow Logs
* GuardDuty enabled
* Security Hub (AWS Best Practices)
* CloudTrail (API auditing)
* AWS Config (compliance tracking)

---

### ☸️ Kubernetes Security

* Non-root containers (`runAsNonRoot`)
* `readOnlyRootFilesystem: true`
* `allowPrivilegeEscalation: false`
* `seccompProfile: RuntimeDefault`
* Resource limits (CPU/Memory)
* Health checks (`livenessProbe`, `readinessProbe`)

---

### 🌐 Kubernetes Network Security

* Implementation of **NetworkPolicy**
* Automated validation via Jenkins pipeline:

  * Allowed client → access granted
  * Blocked client → access denied
* Verified using `curl` and DNS resolution

---

## 📊 Monitoring

* Prometheus for metrics collection
* Grafana for visualization
* Metrics collected:

  * Jenkins
  * Node Exporter (EC2)
  * System metrics

---

## 🧪 Automated Security Testing

The Jenkins pipeline validates:

* Allowed network traffic
* Blocked unauthorized traffic
* Controlled DNS resolution

---

## 📂 Project Structure

```id="en-struct"
terraform/           # AWS infrastructure + Secrets Manager
ansible/             # Jenkins / Prometheus / Grafana setup
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

## 🎯 Goal

This project demonstrates a complete DevSecOps implementation with:

* Shift-left security
* Runtime security (Kubernetes)
* Secure secrets management (Secrets Manager)
* AWS observability and auditing
* Fully automated CI/CD

---

## 📈 Outcome

* Application deployed on EKS
* Fully automated CI/CD pipeline
* Security validated automatically
* Production-like architecture

---

## 👨‍💻 Author

Built as an advanced DevSecOps and Cloud Security project.