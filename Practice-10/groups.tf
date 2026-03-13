resource "aws_iam_group" "military" {
  name = "Military"
  path = "/groups/"
}

resource "aws_iam_group" "security" {
  name = "Security"
  path = "/groups/"
}

resource "aws_iam_group" "navy" {
  name = "Navy"
  path = "/groups/"
}

resource "aws_iam_group_membership" "military_members" {
  name  = "MilitaryGroupMembership"
  group = aws_iam_group.military.name
  users = [
    for user in aws_iam_user.game_of_thrones : user.name if user.tags["department"] == "Military"
  ]
}

resource "aws_iam_group_membership" "security_members" {
  name  = "SecurityGroupMembership"
  group = aws_iam_group.security.name
  users = [
    for user in aws_iam_user.game_of_thrones : user.name if user.tags["department"] == "Security"
  ]
}

resource "aws_iam_group_membership" "navy_members" {
  name  = "NavyGroupMembership"
  group = aws_iam_group.navy.name
  users = [
    for user in aws_iam_user.game_of_thrones : user.name if user.tags["department"] == "Navy"
  ]
}