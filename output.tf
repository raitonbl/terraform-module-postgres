output "users" {
  value = [
    for key in sort([
      for user in local.compute.user_roles : "${user.database_name}_${user.name}"
    ]) : {
      id       = key
      database = substr(key, 0, index(key, "_"))
      refers_to = substr(key, index(key, "_") + 1, length(key))
      username = key
      password = random_password.users[
      "${substr(key, 0, index(key, "_"))}/${substr(key, index(key, "_") + 1, length(key))}"
      ].result
    }
  ]
  sensitive = false
}

output "passwords" {
  value = {
    for key in sort([
      for user in local.compute.user_roles : "${user.database_name}_${user.name}"
    ]) :
    key => random_password.users[
    "${substr(key, 0, index(key, "_"))}/${substr(key, index(key, "_") + 1, length(key))}"
    ].result
  }
  sensitive = true
}
