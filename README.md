# Terraform Module: PostgreSQL Database Management

This Terraform module `dbms_postgres_platform` is designed to provision and manage PostgreSQL databases, users, and
permissions with a flexible and customizable configuration.

## Module Overview

The module allows you to define a map of databases and their associated users, profiles, and grants. It ensures that
database configurations are easy to manage, scalable, and follow best practices.

---

## Inputs

### `databases`

A map of database configurations. Each database can have the following structure:

#### Database Configuration

| **Field** | **Type**        | **Description**                                                                    | **Default** |
|-----------|-----------------|------------------------------------------------------------------------------------|-------------|
| `users`   | List (Optional) | A list of user objects. See [User Configuration](#user-configuration) for details. | `[]`        |

#### User Configuration

Each user in the `users` list can have the following fields:

| **Field**                       | **Type**          | **Description**                                                                                                      | **Default** |
|---------------------------------|-------------------|----------------------------------------------------------------------------------------------------------------------|-------------|
| `name`                          | String (Required) | The name of the user.                                                                                                | -           |
| `profile`                       | String (Optional) | The profile for the user. Enum: `["full-access", "data-access", "read-only-access"]`.                                | `null`      |
| `grants`                        | Object (Optional) | Permissions for the user on various database objects. See [Grants Configuration](#grants-configuration) for details. | `{}`        |
| `maximum_number_of_connections` | Number (Optional) | Maximum connections allowed for the user. `-1` indicates unlimited connections.                                      | `-1`        |

#### Grants Configuration

Grants specify permissions for various database objects. Each grant field is a list of strings representing the objects
the user has access to.

| **Grant Field** | **Type**        | **Description**            | **Default** |
|-----------------|-----------------|----------------------------|-------------|
| `Table`         | List (Optional) | Permissions on tables.     | `[]`        |
| `Function`      | List (Optional) | Permissions on functions.  | `[]`        |
| `Procedure`     | List (Optional) | Permissions on procedures. | `[]`        |
| `Sequence`      | List (Optional) | Permissions on sequences.  | `[]`        |
| `Database`      | List (Optional) | Permissions on databases.  | `[]`        |
| `Schema`        | List (Optional) | Permissions on schemas.    | `[]`        |

### Default Value

```hcl
databases = {}
```

## Module Usage

Below is an example of how to use the dbms_postgres_platform module:

### Example Configuration

```hcl
variable "dbms" {
  type = map(object({
    databases = map(object({
      users = list(object({
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
      }))
    }))
  }))
  default = {
    platform = {
      databases = {
        example_db = {
          users = [
            {
              name    = "example_user"
              profile = "full-access"
              grants = {
                Table = ["table1", "table2"]
                Schema = ["public"]
              }
              maximum_number_of_connections = 10
            }
          ]
        }
      }
    }
  }
}

module "dbms_postgres_platform" {
  name      = "default"
  source    = "<appropriate url/>"
  providers = { postgresql = postgresql.platform }
  databases = var.dbms["platform"].databases
}
```

## Outputs

### users

This output provides the usernames and passwords of the users created for the databases.

| Key	      | Type	   | Description                                    | 	Sensitive |
|-----------|---------|------------------------------------------------|------------|
| username	 | String	 | The username of the database user. (Generated) | 	No        |
| password	 | String	 | The password of the database user. (Generated) | 	Yes       |

## Requirements

* Terraform version: >= 1.0
* Provider: postgresql

## Providers

| Provider	   | Description                                                               | 
|-------------|---------------------------------------------------------------------------|
| postgresql	 | Manages PostgreSQL resources, including databases, users, and permissions |
