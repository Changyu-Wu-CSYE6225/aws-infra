# Wepapp kms key
resource "aws_kms_key" "ebs_kms_key" {
  description             = "webapp KMS key"
  deletion_window_in_days = 7

  policy = jsonencode({
    Statement = [
      {
        Action = [
          "kms:*",
          #   "kms:Update*",
          #   "kms:Encrypt",
          #   "kms:Decrypt",
          #   "kms:ReEncrypt*",
          #   "kms:GenerateDataKey*",
          #   "kms:CreateGrant",
          #   "kms:DescribeKey",
        ]
        Effect = "Allow"
        Principal = {
          AWS = ["*"]
        }
        Resource = "*"
        Sid      = "Enable IAM User Permissions in kms"
      },
    ]
    Version = "2012-10-17"
  })
}


# RDS kms key
resource "aws_kms_key" "rds_kms_key" {
  description             = "RDS KMS key"
  deletion_window_in_days = 7

  policy = jsonencode({
    Statement = [
      {
        Action = [
          "kms:*",
          #   "kms:Update*",
          #   "kms:UntagResource",
          #   "kms:TagResource",
          #   "kms:ScheduleKeyDeletion",
          #   "kms:Revoke*",
          #   "kms:Put*",
          #   "kms:List*",
          #   "kms:Get*",
          #   "kms:Enable*",
          #   "kms:Disable*",
          #   "kms:Describe*",
          #   "kms:Delete*",
          #   "kms:Create*",
          #   "kms:CancelKeyDeletion",
        ]
        Effect = "Allow"
        Principal = {
          AWS = ["*"]
        }
        Resource = "*"
        Sid      = "Enable IAM User Permissions in kms"
      }
    ]
    Version = "2012-10-17"
  })
}
