resource "aws_iam_user" "game_of_thrones" {
  for_each = { for user in local.users : user.firstname => user }

  name = "${substr(each.value.firstname, 0, 1)}${each.value.lastname}"
  path = "/users/"

  tags = {
    display_name = lower("${each.value.firstname}${each.value.lastname}")
    department   = "${each.value.department}"
    job_title    = "${each.value.job_title}"
  }
}

resource "aws_iam_user_login_profile" "users" {
  for_each                = aws_iam_user.game_of_thrones
  user                    = each.value.name
  password_reset_required = true

  lifecycle {
    ignore_changes = [ password_reset_required, password_length ]
  }
}

resource "aws_secretsmanager_secret" "user_password" {
  for_each = aws_iam_user.game_of_thrones

  name        = "${each.value.name}_password"
  description = "Password for IAM user ${each.value.name}"
}

