resource "postgresql_database" "database" {
  for_each          = var.databases
  name              = each.key
  allow_connections = true
  encoding          = "UTF8"
}

resource "postgresql_role" "users" {
  for_each = {
    for user_role in local.compute.user_roles :
    "${user_role.database_name}/${user_role.name}" => {
      user        = user_role
      username = "${user_role.database_name}_${user_role.name}"
      secret_path = "${user_role.database_name}/${user_role.name}"
    }
  }
  login            = true
  name             = each.value.username
  connection_limit = each.value.user.maximum_number_of_connections
  password         = random_password.users[each.value.secret_path].result
  superuser        = false
  create_database  = false
  depends_on = [postgresql_database.database]
}

resource "random_password" "users" {
  for_each = {
    for user_role in local.compute.user_roles :
    "${user_role.database_name}/${user_role.name}" => user_role
  }
  length           = 16
  special          = true
  upper            = true
  lower            = true
  numeric          = true
  override_special = "!@#$%^&*()-_=+"
}

resource "postgresql_grant" "user_grants" {
  for_each = {
    for grant in local.compute.user_grants :
    "${grant.database}/${grant.username}/${grant.object_type}" => grant
  }
  schema      = "public"
  database    = each.value.database
  role        = "${each.value.database}_${each.value.username}"
  object_type = each.value.object_type
  privileges  = each.value.privileges
  depends_on = [postgresql_role.users]
}