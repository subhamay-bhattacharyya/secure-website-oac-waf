# -- infra/aws/tf/validations.tf
# ============================================================================
# Config assertions — fail plan early when required conventions are violated.
# ============================================================================

resource "terraform_data" "validate_s3_bucket_name" {
  lifecycle {
    precondition {
      condition     = can(regex("^[a-z0-9][a-z0-9-]{1,61}[a-z0-9]$", local.aws_config.s3.bucket_name))
      error_message = <<-EOT
        Invalid S3 bucket name in config JSON.

        `aws.s3.bucket_name` must contain only lowercase letters, numbers, and hyphens,
        must start and end with a letter or number, and be between 3 and 63 characters.

        Current value: "${local.aws_config.s3.bucket_name}"
      EOT
    }
  }
}

resource "terraform_data" "validate_lifecycle_rules" {
  lifecycle {
    precondition {
      condition = alltrue([
        for rule in try(local.aws_config.s3.lifecycle_rules, []) :
        can(rule.id) && rule.id != "" && rule.expiration_days > 0
      ])
      error_message = <<-EOT
        Invalid lifecycle rule in config JSON.

        Each entry in `aws.s3.lifecycle_rules` must have a non-empty `id`
        and `expiration_days` greater than 0.
      EOT
    }
  }
}
