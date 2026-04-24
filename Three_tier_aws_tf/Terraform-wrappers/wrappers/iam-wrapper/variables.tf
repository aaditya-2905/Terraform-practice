variable "aws_region" {
  description = "AWS region where resources will be deployed"
  type        = string
  default     = "us-east-1"
}

variable "role_name" {
  description = "Name of the IAM role"
  type        = string
  default     = null
}

variable "assume_role_policy" {
  description = "Assume role policy JSON document"
  type        = string
  default     = null
}

variable "role_description" {
  description = "Description of the IAM role"
  type        = string
  default     = null
}

variable "role_path" {
  description = "Path for the IAM role"
  type        = string
  default     = "/"
}

variable "policy_name" {
  description = "Name of the IAM policy"
  type        = string
  default     = null
}

variable "policy_description" {
  description = "Description of the IAM policy"
  type        = string
  default     = null
}

variable "policy_path" {
  description = "Path for the IAM policy"
  type        = string
  default     = "/"
}

variable "policy_json" {
  description = "Policy JSON document"
  type        = string
  default     = null
}

variable "user_name" {
  description = "Name of the IAM user"
  type        = string
  default     = null
}

variable "user_path" {
  description = "Path for the IAM user"
  type        = string
  default     = "/"
}

variable "create_login_profile" {
  description = "Whether to create a login profile for the user"
  type        = bool
  default     = false
}

variable "password_reset_required" {
  description = "Whether the user is required to reset password on first login"
  type        = bool
  default     = true
}

variable "create_access_key" {
  description = "Whether to create an access key for the user"
  type        = bool
  default     = false
}

variable "access_key_status" {
  description = "Status of the access key (Active or Inactive)"
  type        = string
  default     = "Active"

  validation {
    condition     = contains(["Active", "Inactive"], var.access_key_status)
    error_message = "access_key_status must be either 'Active' or 'Inactive'."
  }
}

variable "policy_arns" {
  description = "List of IAM policy ARNs to attach to the role or user"
  type        = list(string)
  default     = []
}

variable "users" {
  description = "Map of IAM users to create"
  type = map(object({
    path                    = optional(string, "/")
    create_login_profile    = optional(bool, false)
    password_reset_required = optional(bool, true)
    create_access_key       = optional(bool, false)
    access_key_status       = optional(string, "Active")
    tags                    = optional(map(string), {})
  }))
  default = {}
}

variable "roles" {
  description = "Map of IAM roles to create"
  type = map(object({
    assume_role_policy = string
    description        = optional(string, null)
    path               = optional(string, "/")
    tags               = optional(map(string), {})
  }))
  default = {}
}

variable "policies" {
  description = "Map of IAM policies to create"
  type = map(object({
    policy_document = string
    description     = optional(string, null)
    path            = optional(string, "/")
    tags            = optional(map(string), {})
  }))
  default = {}
}

variable "groups" {
  description = "Map of IAM groups to create"
  type = map(object({
    path = optional(string, "/")
    tags = optional(map(string), {})
  }))
  default = {}
}

variable "policy_attachments" {
  description = "Attach policies to roles and users. Format: 'role:role_name:policy_arn' or 'user:user_name:policy_arn'"
  type        = list(string)
  default     = []
}

variable "group_memberships" {
  description = "Add users to groups. Format: 'group_name:user_name'"
  type        = list(string)
  default     = []
}

variable "tags" {
  description = "Tags to apply to all resources"
  type        = map(string)
  default     = {}
}
