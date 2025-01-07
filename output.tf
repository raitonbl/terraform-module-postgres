output "users" {
  value = [
    for v in local.compute.user_roles :
    {
      refers_to = v.name
      database = v.database_name
      username = "${v.database_name}_${v.name}"
      password = random_password.users["${v.database_name}/${v.name}"].result
    }
  ]
  sensitive = true
}
