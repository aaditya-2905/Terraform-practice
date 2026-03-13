output "usernames" {
  value = [for user in local.users : "${user.firstname} ${user.lastname}"]
}
