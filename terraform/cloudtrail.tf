############################################
# Data sources
############################################

data "aws_caller_identity" "current" {}

############################################
# S3 bucket for CloudTrail logs
############################################

resource "aws_s3_bucket" "cloudtrail_bucket" {
  bucket = "${var.project}-cloudtrail-${data.aws_caller_identity.current.account_id}"

  force_destroy = true

  tags = {
    Name    = "${var.project}-cloudtrail-bucket"
    Project = var.project
  }
}

resource "aws_s3_bucket_versioning" "cloudtrail_bucket_versioning" {
  bucket = aws_s3_bucket.cloudtrail_bucket.id

  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_s3_bucket_server_side_encryption_configuration" "cloudtrail_bucket_sse" {
  bucket = aws_s3_bucket.cloudtrail_bucket.id

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}

resource "aws_s3_bucket_public_access_block" "cloudtrail_bucket_pab" {
  bucket = aws_s3_bucket.cloudtrail_bucket.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

############################################
# Optional lifecycle for CloudTrail logs
############################################

resource "aws_s3_bucket_lifecycle_configuration" "cloudtrail_bucket_lifecycle" {
  bucket = aws_s3_bucket.cloudtrail_bucket.id

  rule {
    id     = "expire-old-cloudtrail-logs"
    status = "Enabled"

    filter {
      prefix = ""
    }

    expiration {
      days = 90
    }

    noncurrent_version_expiration {
      noncurrent_days = 30
    }
  }
}

############################################
# Bucket policy for CloudTrail
############################################

resource "aws_s3_bucket_policy" "cloudtrail_bucket_policy" {
  bucket = aws_s3_bucket.cloudtrail_bucket.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid    = "AWSCloudTrailAclCheck"
        Effect = "Allow"
        Principal = {
          Service = "cloudtrail.amazonaws.com"
        }
        Action   = "s3:GetBucketAcl"
        Resource = aws_s3_bucket.cloudtrail_bucket.arn
      },
      {
        Sid    = "AWSCloudTrailWrite"
        Effect = "Allow"
        Principal = {
          Service = "cloudtrail.amazonaws.com"
        }
        Action   = "s3:PutObject"
        Resource = "${aws_s3_bucket.cloudtrail_bucket.arn}/AWSLogs/${data.aws_caller_identity.current.account_id}/*"
        Condition = {
          StringEquals = {
            "s3:x-amz-acl" = "bucket-owner-full-control"
          }
        }
      }
    ]
  })
}

############################################
# CloudTrail
############################################

resource "aws_cloudtrail" "main" {
  name                          = "${var.project}-trail"
  s3_bucket_name                = aws_s3_bucket.cloudtrail_bucket.id
  include_global_service_events = true
  is_multi_region_trail         = true
  enable_log_file_validation    = true

  # Management events
  event_selector {
    read_write_type           = "All"
    include_management_events = true
  }

  # S3 object-level data events
  dynamic "event_selector" {
    for_each = length(var.cloudtrail_s3_data_event_arns) > 0 ? [1] : []

    content {
      read_write_type           = "All"
      include_management_events = false

      data_resource {
        type   = "AWS::S3::Object"
        values = var.cloudtrail_s3_data_event_arns
      }
    }
  }

  depends_on = [aws_s3_bucket_policy.cloudtrail_bucket_policy]

  tags = {
    Name    = "${var.project}-trail"
    Project = var.project
  }
}