# -- infra/platform/tf/variables.tf (Platform Module)
# ============================================================================
# Platform Module Variables
# ============================================================================

variable "environment" {
  description = "Environment name (devl, test, prod)"
  type        = string
  default     = "ci"

  validation {
    condition     = contains(["ci", "devl", "test", "prod"], var.environment)
    error_message = "Environment must be devl, test, or prod."
  }
}

variable "project_code" {
  description = "Project code prefix for resource naming (e.g., snw-lkh)"
  type        = string
  default     = "tstybyt"
}

# ============================================================================
# Configuration File Paths
# ============================================================================

variable "aws_config_path" {
  description = "Path to AWS config JSON file (relative to module)"
  type        = string
  default     = "config/aws/devl/config.json"
}

# ============================================================================
# Tagging Metadata (injected from CI; safe defaults for local runs)
# ============================================================================

variable "git_ref" {
  description = "Git ref (branch or tag) that produced this apply. Set via TF_VAR_git_ref in CI."
  type        = string
  default     = "local"
}

variable "git_commit_sha" {
  description = "Short git commit SHA. Set via TF_VAR_git_commit_sha in CI."
  type        = string
  default     = "local"
}

variable "cost_center" {
  description = "Cost center for billing allocation."
  type        = string
  default     = "data-platform"
}

variable "component" {
  description = "Component name within the project (e.g., platform, ingestion, dashboard)."
  type        = string
  default     = "platform"
}

variable "owner" {
  description = "Owning team for the resources."
  type        = string
  default     = "data-platform"
}

variable "data_classification" {
  description = "Data classification tier (public, internal, confidential, restricted)."
  type        = string
  default     = "confidential"
}

variable "repository" {
  description = "GitHub repository name (owner/repo). Set via TF_VAR_repository in CI."
  type        = string
  default     = ""
}  