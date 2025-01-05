output "users" {
  value = [
    for k, v in postgresql_role.users :
    {
      username = v.name
      password = random_password.users[k]
    }
  ]
  sensitive = true
}
