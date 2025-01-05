variable "databases" {
  type = map(object({
    users = optional(list(object({
      name = string
      profile = optional(string, null)
      grants = optional(object({
        Table = optional(list(string), [])
        Function = optional(list(string), [])
        Procedure = optional(list(string), [])
        Sequence = optional(list(string), [])
        Database = optional(list(string), [])
        Schema = optional(list(string), [])
      }), {})
      maximum_number_of_connections = optional(number, -1)
    })), [])
  }))
  description = <<EOT
A map of database configurations where each database can have the following properties:
- **users**: (Optional) A list of user objects, each containing:
  - **name**: (Required) The name of the User.
  - **profile**: (Optional) A string specifying the profile to be used for the user, defaults to `null`. Enum ["full-access","data-access","read-only-acess"]
  - **grants**: (Optional) An object specifying the permissions for various database objects:
    - **Table**: (Optional) A list of permissions granted to the user.
    - **Function**: (Optional) A list of permissions granted to the user.
    - **Procedure**: (Optional) A list of permissions granted to the user.
    - **Sequence**: (Optional) A list of permissions granted to the user.
    - **Database**: (Optional) A list of permissions granted to the user.
    - **Schema**: (Optional) A list of permissions granted to the user.
  - **maximum_number_of_connections**: (Optional) A number specifying the maximum connections allowed for the user, defaults to `-1` (unlimited).
EOT
  default = {}
}
