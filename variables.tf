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


variable "settings" {
  description = <<-EOT
    Defines global configuration settings, including an optional password policy used for generating random passwords.

    The "password_policy" object allows you to customize the generated passwords by specifying:
      - length: The total length of the generated password (default: 16).
      - has_special_characters: Whether to include special characters (default: true).
      - has_uppercase_characters: Whether to include uppercase letters (default: true).
      - has_lowercase_characters: Whether to include lowercase letters (default: true).
      - has_numeric_characters: Whether to include numeric characters (default: true).
      - override_special_characters: A custom set of special characters to use instead of the defaults (default: "!@#$%^&*()-_=+").
      - minimum_uppercase_characters_occurrences: Minimum required occurrences of uppercase letters (default: null).
      - minimum_lowercase_characters_occurrences: Minimum required occurrences of lowercase letters (default: null).
      - minimum_numeric_characters_occurrences: Minimum required occurrences of numeric characters (default: null).
      - minimum_special_characters_occurrences: Minimum required occurrences of special characters (default: null).

    The password policy object is optional. If not provided, the defaults shown above will be used.
  EOT

  type = object({
    password_policy = optional(object({
      has_special_characters                       = bool
      has_uppercase_characters                     = bool
      has_lowercase_characters                     = bool
      has_numeric_characters                       = bool
      length                                       = number
      override_special_characters                  = string
      minimum_uppercase_characters_occurrences   = optional(number, null)
      minimum_lowercase_characters_occurrences   = optional(number, null)
      minimum_numeric_characters_occurrences     = optional(number, null)
      minimum_special_characters_occurrences     = optional(number, null)
    }), {
      length                      = 16
      has_special_characters      = true
      has_uppercase_characters    = true
      has_lowercase_characters    = true
      has_numeric_characters      = true
      override_special_characters = "!@#$%^&*()-_=+"
    })
  })
  default = {}
}
