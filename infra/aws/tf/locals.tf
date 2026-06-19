# -- infra/platform/tf/locals.tf (Platform Module)
# ============================================================================
# Local Values
# ============================================================================

data "aws_caller_identity" "current" {}

# Compute KMS key alias first (no dependency on s3_config)
locals {
  kms_key_alias_raw = try(jsondecode(file("${path.module}/${var.aws_config_path}")).aws.s3.kms_key_alias, null)
  kms_key_alias     = local.kms_key_alias_raw != null ? (startswith(local.kms_key_alias_raw, "alias/") ? local.kms_key_alias_raw : "alias/${local.kms_key_alias_raw}") : null
}

data "aws_kms_key" "kms" {
  count  = local.kms_key_alias != null ? 1 : 0
  key_id = local.kms_key_alias
}

locals {
  # ============================================================================
  # Default tags (applied to every AWS resource via provider default_tags)
  # ============================================================================
  default_tags = {
    Project            = var.project_code
    Environment        = var.environment
    ManagedBy          = "Terraform"
    Repository         = var.repository != "" ? var.repository : null
    Component          = var.component
    Owner              = var.owner
    CostCenter         = var.cost_center
    DataClassification = var.data_classification
    GitRef             = var.git_ref
    GitCommitSHA       = var.git_commit_sha
  }

  # Parse config from JSON files (relative to module path)
  aws_config_file = jsondecode(file("${path.module}/${var.aws_config_path}"))

  # Extract nested sections
  aws_config = local.aws_config_file.aws

  # ============================================================================
  # AWS Configuration
  # ============================================================================


  # S3 Configuration
  s3_config = {
    bucket_name   = "${var.project_code}-${local.aws_config.s3.bucket_name}-${var.environment}-${local.aws_config.region}"
    versioning    = local.aws_config.s3.versioning == true ? true : false
    kms_key_alias = local.kms_key_alias != null ? replace(local.kms_key_alias, "alias/", "") : null
    sse_algorithm = local.kms_key_alias != null ? "aws:kms" : null
    bucket_keys   = try(local.aws_config.s3.bucket_keys, null)
    # bucket_policy = templatefile("${path.module}/templates/bucket-policy/s3-bucket-policy.tpl", {
    #   aws_account_id = data.aws_caller_identity.current.account_id
    #   bucket_name    = "${var.project_code}-${local.aws_config.s3.bucket_name}-${var.environment}-${local.aws_config.region}"
    # })
  }
}