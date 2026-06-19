# -- infra/platform/tf/outputs.tf (Platform Module)
# ============================================================================
# Platform Module Outputs
# ============================================================================

# ============================================================================
# AWS Outputs
# ============================================================================

# ----------------------------------------------------------------------------
# S3 Bucket Outputs
# ----------------------------------------------------------------------------
output "s3_bucket" {
  description = "S3 bucket details for Snowflake external stage"
  value = {
    name              = module.s3.bucket_id
    arn               = module.s3.bucket_arn
    region            = module.s3.bucket_region
    versioning_status = module.s3.versioning_status
  }
}
