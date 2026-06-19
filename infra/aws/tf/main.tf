# -- infra/aws/tf/main.tf
# ============================================================================
#
# ┌─────────────────────────────────────────────────────────────┐
# │  PHASE 1: AWS Resources                                     │
# ├─────────────────────────────────────────────────────────────┤
# │  • 1.1 S3 Bucket (Website files)                            │
# └─────────────────────────────────────────────────────────────┘

# module "s3" {
#   source = "git::https://github.com/subhamay-bhattacharyya-tf/terraform-aws-s3.git//modules/bucket?ref=v1.0.0"

#   s3_config = local.s3_config
# }

resource "null_resource" "placeholder" {}