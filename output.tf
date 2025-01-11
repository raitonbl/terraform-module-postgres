output "users" {
  value = [
    for v in sort([for user in local.compute.user_roles : "${user.database_name}_${user.name}"]) : {
      refers_to = split("_", v)[1]
      database  = split("_", v)[0]
      username  = v
      password  = random_password.users["${split("_", v)[0]}/${split("_", v)[1]}"].result
    }
  ]
  sensitive = true
}
