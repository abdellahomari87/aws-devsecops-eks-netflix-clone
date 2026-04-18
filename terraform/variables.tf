variable "region" {
  type    = string
  default = "us-east-1"
}

variable "project" {
  type    = string
  default = "netflix-devsecops"
}


# Buckets S3 à surveiller au niveau objet avec CloudTrail
# Exemple:
# [
#   "arn:aws:s3:::mon-bucket-app/",
#   "arn:aws:s3:::mon-bucket-docs/"
# ]

variable "cloudtrail_s3_data_event_arns" {
  type        = list(string)
  description = "S3 buckets for CloudTrail data events"
  default     = []
}

variable "key_name" {
  type        = string
  description = "Nom de ta key pair EC2 déjà existante (ex: my-key)."
}

variable "allowed_ssh_cidr" {
  type        = string
  description = "Ton IP publique /32 pour SSH (ex: 1.2.3.4/32)."
}

variable "instance_type_cicd" {
  type    = string
  default = "t3.large"
}

variable "instance_type_monitoring" {
  type    = string
  default = "t3.large"
}

variable "eks_cluster_name" {
  type    = string
  default = "netflix-eks"
}

variable "eks_node_group_name" {
  type    = string
  default = "netflix-node-group"
}

variable "eks_instance_types" {
  type    = list(string)
  default = ["t3.medium"]
}

variable "eks_desired_size" {
  type    = number
  default = 2
}

variable "eks_min_size" {
  type    = number
  default = 1
}

variable "eks_max_size" {
  type    = number
  default = 3
}