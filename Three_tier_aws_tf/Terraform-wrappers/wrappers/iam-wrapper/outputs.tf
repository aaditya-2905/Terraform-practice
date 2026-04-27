output "users" {
  description = "Map of created IAM users with details"
  value = {
    for name, user in aws_iam_user.this :
    name => {
      arn       = user.arn
      name      = user.name
      unique_id = user.unique_id
    }
  }
}

output "access_keys" {
  description = "Map of access keys created for users (sensitive)"
  value = {
    for user_name, key in aws_iam_access_key.this :
    user_name => {
      access_key_id     = key.id
      access_key_secret = key.secret
      ses_smtp_password = key.ses_smtp_password
    }
  }
  sensitive = true
}

output "roles" {
  description = "Map of created IAM roles with details"
  value = {
    for name, role in aws_iam_role.this :
    name => {
      arn  = role.arn
      name = role.name
      id   = role.id
    }
  }
}

output "policies" {
  description = "Map of created IAM policies with details"
  value = {
    for name, policy in aws_iam_policy.this :
    name => {
      arn  = policy.arn
      name = policy.name
      id   = policy.id
    }
  }
}

output "groups" {
  description = "Map of created IAM groups with details"
  value = {
    for name, group in aws_iam_group.this :
    name => {
      arn  = group.arn
      name = group.name
      id   = group.id
    }
  }
}

# Preserve old outputs in case they were referenced by other root configurations
output "role_arns" {
  description = "ARNs of created IAM roles"
  value       = { for k, v in aws_iam_role.this : k => v.arn }
}

output "user_arns" {
  description = "ARNs of created IAM users"
  value       = { for k, v in aws_iam_user.this : k => v.arn }
}
