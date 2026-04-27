locals {
  # Common tags for all resources
  common_tags = merge(
    var.tags,
    {
      created_by = "terraform"
      module     = "iam-wrapper"
    }
  )

  # Parse policy attachments
  # Format "role:role_name:policy_arn" or "user:user_name:policy_arn"
  policy_attachment_list = [
    for attachment in var.policy_attachments : {
      type       = split(":", attachment)[0]
      name       = split(":", attachment)[1]
      policy_arn = join(":", slice(split(":", attachment), 2, length(split(":", attachment))))
    }
  ]

  # Role policy attachments
  role_policy_attachments = {
    for idx, item in local.policy_attachment_list :
    "role_${idx}" => item
    if item.type == "role"
  }

  # User policy attachments
  user_policy_attachments = {
    for idx, item in local.policy_attachment_list :
    "user_${idx}" => item
    if item.type == "user"
  }

  # Parse group memberships: format "group_name:user_name"
  membership_list = [
    for membership in var.group_memberships :
    split(":", membership)
  ]

  group_memberships = {
    for idx, parts in local.membership_list :
    "${parts[0]}_${idx}" => {
      group = parts[0]
      user  = parts[1]
    }
  }
}

resource "aws_iam_role" "this" {
  for_each = var.roles

  name               = each.key
  path               = each.value.path
  assume_role_policy = each.value.assume_role_policy
  description        = each.value.description
  tags               = merge(local.common_tags, each.value.tags)
}

resource "aws_iam_policy" "this" {
  for_each = var.policies

  name        = each.key
  path        = each.value.path
  description = each.value.description
  policy      = each.value.policy_document
  tags        = merge(local.common_tags, each.value.tags)
}

resource "aws_iam_user" "this" {
  for_each = var.users

  name = each.key
  path = each.value.path
  tags = merge(local.common_tags, each.value.tags)
}

resource "aws_iam_user_login_profile" "this" {
  for_each = {
    for user, user_config in var.users :
    user => user_config
    if user_config.create_login_profile
  }

  user                    = aws_iam_user.this[each.key].name
  password_reset_required = each.value.password_reset_required
  password_length         = 20

  lifecycle {
    ignore_changes = [password_reset_required]
  }
}

resource "aws_iam_access_key" "this" {
  for_each = {
    for user_name, user_config in var.users :
    user_name => user_config
    if user_config.create_access_key
  }

  user   = aws_iam_user.this[each.key].name
  status = each.value.access_key_status
}

resource "aws_iam_group" "this" {
  for_each = var.groups

  name = each.key
  path = each.value.path
}

resource "aws_iam_role_policy_attachment" "this" {
  for_each = local.role_policy_attachments

  role       = each.value.name
  policy_arn = each.value.policy_arn
  
  depends_on = [aws_iam_role.this, aws_iam_policy.this]
}

resource "aws_iam_user_policy_attachment" "this" {
  for_each = local.user_policy_attachments

  user       = each.value.name
  policy_arn = each.value.policy_arn
  
  depends_on = [aws_iam_user.this, aws_iam_policy.this]
}

resource "aws_iam_user_group_membership" "this" {
  for_each = local.group_memberships

  user   = each.value.user
  groups = [each.value.group]

  depends_on = [aws_iam_group.this, aws_iam_user.this]
}
