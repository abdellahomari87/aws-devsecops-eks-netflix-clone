############################################
# DATA
############################################

data "aws_region" "current" {}

############################################
# S3 BUCKET FOR VPC FLOW LOGS
############################################

resource "aws_s3_bucket" "vpc_flow_logs" {
  bucket = "${var.project}-vpc-flow-logs-${data.aws_caller_identity.current.account_id}"

  force_destroy = true

  tags = {
    Name    = "${var.project}-vpc-flow-logs"
    Project = var.project
  }
}

resource "aws_s3_bucket_server_side_encryption_configuration" "vpc_flow_logs" {
  bucket = aws_s3_bucket.vpc_flow_logs.id

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}

resource "aws_s3_bucket_public_access_block" "vpc_flow_logs" {
  bucket = aws_s3_bucket.vpc_flow_logs.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

############################################
# S3 BUCKET POLICY FOR VPC FLOW LOGS
############################################

resource "aws_s3_bucket_policy" "vpc_flow_logs" {
  bucket = aws_s3_bucket.vpc_flow_logs.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid    = "AWSLogDeliveryWrite"
        Effect = "Allow"
        Principal = {
          Service = "delivery.logs.amazonaws.com"
        }
        Action   = "s3:PutObject"
        Resource = "${aws_s3_bucket.vpc_flow_logs.arn}/AWSLogs/${data.aws_caller_identity.current.account_id}/*"
        Condition = {
          StringEquals = {
            "aws:SourceAccount" = data.aws_caller_identity.current.account_id
            "s3:x-amz-acl"      = "bucket-owner-full-control"
          }
        }
      },
      {
        Sid    = "AWSLogDeliveryAclCheck"
        Effect = "Allow"
        Principal = {
          Service = "delivery.logs.amazonaws.com"
        }
        Action = [
          "s3:GetBucketAcl",
          "s3:ListBucket"
        ]
        Resource = aws_s3_bucket.vpc_flow_logs.arn
        Condition = {
          StringEquals = {
            "aws:SourceAccount" = data.aws_caller_identity.current.account_id
          }
        }
      }
    ]
  })
}

############################################
# FLOW LOGS - DEFAULT VPC
############################################

resource "aws_flow_log" "project_vpc_flow_log" {
  vpc_id               = module.vpc.vpc_id
  traffic_type         = "ALL"
  log_destination_type = "s3"
  log_destination      = aws_s3_bucket.vpc_flow_logs.arn

  tags = {
    Name    = "${var.project}-project-vpc-flow-log"
    Project = var.project
  }

  depends_on = [
    aws_s3_bucket.vpc_flow_logs,
    aws_s3_bucket_policy.vpc_flow_logs
  ]
}

############################################
# FLOW LOGS - EKS VPC
############################################

resource "aws_flow_log" "eks_vpc_flow_log" {
  vpc_id               = aws_vpc.eks_vpc.id
  traffic_type         = "ALL"
  log_destination_type = "s3"
  log_destination      = aws_s3_bucket.vpc_flow_logs.arn

  tags = {
    Name    = "${var.project}-eks-vpc-flow-log"
    Project = var.project
  }

  depends_on = [
    aws_s3_bucket.vpc_flow_logs,
    aws_s3_bucket_policy.vpc_flow_logs
  ]
}