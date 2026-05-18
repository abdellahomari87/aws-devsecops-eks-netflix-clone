# ☁️ AWS DevSecOps EKS Netflix Clone

## 📌 Description

This repository contains the complete cloud infrastructure, DevSecOps automation, CI/CD pipeline, monitoring stack, and AWS security integrations used to deploy and secure the Netflix Clone application on AWS.

The project was designed to modernize a traditional application deployment into a production-like DevSecOps platform using Infrastructure as Code, Kubernetes, cloud automation, and security best practices.

---

# 🎯 Project Objectives

- Automate AWS infrastructure provisioning
- Deploy applications securely on Amazon EKS
- Implement a complete CI/CD pipeline
- Apply DevSecOps and Shift-Left Security practices
- Integrate AWS cloud security services
- Implement Kubernetes runtime security
- Build a production-like cloud architecture
- Minimize manual AWS console operations

---

# 🏗️ Architecture Overview

## ☁️ Cloud Platform

- AWS

## ☸️ Container Orchestration

- Amazon EKS
- Kubernetes

## ⚙️ Infrastructure as Code

- Terraform

## 🤖 Automation & Configuration

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

## 🔐 Security

### AWS Security

- AWS GuardDuty
- AWS Security Hub
- AWS Config
- AWS CloudTrail
- IAM Least Privilege
- IMDSv2 enabled
- EBS Encryption
- VPC Flow Logs

### DevSecOps Security

- Trivy
- OWASP Dependency Check
- SonarQube

### Kubernetes Security

- NetworkPolicy
- Pod Security hardening
- Runtime security best practices

---

# 🚀 Infrastructure Automation

The infrastructure is fully provisioned using Terraform.

## Terraform Components

- VPC
- Subnets
- Security Groups
- EC2 Instances
- IAM Roles & Policies
- Amazon EKS
- Secrets Manager
- Monitoring infrastructure

---

# 🤖 Ansible Automation

Ansible is used to automate:

- Jenkins installation
- Docker installation
- Monitoring setup
- SonarQube setup
- Prometheus & Grafana configuration
- Jenkins Configuration as Code (JCasC)
- Security configuration

---

# ⚙️ Jenkins & CI/CD

The Jenkins pipeline automates:

- Application build
- Static code analysis
- Security scanning
- Docker image build
- Docker image push
- Kubernetes deployment
- Security validation tests

---

# 🔐 Secure Secret Management

Secrets are securely stored using AWS Secrets Manager.

## Managed Secrets

- DockerHub credentials
- SonarQube tokens
- API keys
- Jenkins credentials
- Grafana credentials
- Webhook secrets

## Security Features

- Secret creation with Terraform
- IAM Role-based access
- Runtime secret injection
- No secrets exposed in Git repositories

---

# ☸️ Kubernetes Security

The project applies Kubernetes security best practices:

- `runAsNonRoot`
- `readOnlyRootFilesystem`
- `allowPrivilegeEscalation: false`
- `seccompProfile: RuntimeDefault`
- CPU & Memory limits
- Liveness & Readiness probes
- NetworkPolicy isolation

---

# 🌐 Kubernetes Network Policies

Automated tests validate:

- Allowed traffic
- Blocked traffic
- DNS resolution
- Pod isolation
- Secure namespace communication

---

# 📊 Monitoring Stack

## Prometheus

Used for metrics collection:

- Jenkins metrics
- Kubernetes metrics
- EC2 metrics
- System metrics

## Grafana

Used for:

- Dashboards
- Infrastructure visualization
- Monitoring alerts

---

# 📂 Repository Structure

terraform/
ansible/
monitoring/

Jenkinsfile
README-english.md
README-français.md

# 🔗 Related Repository

Application source code repository:

👉 https://github.com/abdellahomari87/Netflix-clone-abdellah
