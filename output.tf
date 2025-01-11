output "users" {
  value = tomap({
    for user in local.compute.user_roles :
    "${user.database_name}_${user.name}" => {
      refers_to = user.name
      database  = user.database_name
      username  = "${user.database_name}_${user.name}"
    }
  })
  sensitive = false
}

output "passwords" {
  value = tomap({
    for user in local.compute.user_roles :
    "${user.database_name}_${user.name}" => random_password.users[
    "${user.database_name}/${user.name}"
    ].result
  })
  sensitive = true
}
