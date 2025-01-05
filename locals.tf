locals {
  profiles = {
    "full-access" = {
      grants = {
        Table = ["SELECT", "INSERT", "UPDATE", "DELETE", "TRUNCATE", "REFERENCES", "TRIGGER"]
        Function = ["EXECUTE"]
        Procedure = ["EXECUTE"]
        Sequence = ["SELECT", "USAGE"]
        Database = ["CONNECT", "CREATE", "TEMPORARY"]
        Schema = ["USAGE", "CREATE"]
      }
    }
    "data-access" = {
      grants = {
        Table = ["SELECT", "INSERT", "UPDATE", "DELETE", "REFERENCES"]
        Function = ["EXECUTE"]
        Procedure = []
        Sequence = ["SELECT", "USAGE"]
        Database = ["CONNECT"]
        Schema = ["USAGE"]
      }
    }
    "read-only-acess" = {
      grants = {
        Table = ["SELECT"]
        Function = ["EXECUTE"]
        Procedure = []
        Sequence = ["SELECT"]
        Database = ["CONNECT"]
        Schema = ["USAGE"]
      }
    }
  }
  compute = {
    user_roles = flatten([
      for db_key, db in var.databases : [
        for user in db.users : {
          database_name = db_key
          name          = user.name
          maximum_number_of_connections = lookup(user, "maximum_number_of_connections", -1)
        }
      ]
    ])
    user_grants = flatten([
      for db_name, db_config in var.databases : [
        for user in db_config.users : [
          for grant_object, grants in (
            user.profile != null && lookup(local.profiles, user.profile, null) != null ?
            lookup(local.profiles, user.profile, { grants = {} }).grants : user.grants
          ) :
          {
            database   = db_name
            username   = user.name
            object_type = lower(grant_object)
            privileges = grants
          }
        ]
      ]
    ])
  }
}