# upper.io/db/mysql

The `upper.io/db/mysql` adapter for [MySQL][2] makes use of the
`github.com/go-sql-driver/mysql` package, by [Julien Schmidt][1].

## Installation

Use `go get` to download and install the adapter:

```go
go get upper.io/db/mysql
```

## Usage

To use this adapter, import `upper.io/db` and the `upper.io/db/mysql` packages.
Note that the adapter must be imported to the [blank identifier][2].

```go
# main.go
package main

import (
  "upper.io/db"
  _ "upper.io/db/mysql"
)
```

Then, you can use the `db.Open()` method to connect to a MySQL server:

```go
var settings = db.Settings{
  Host:     "localhost",  // MySQL server IP or name.
  Database: "peanuts",    // Database name.
  User:     "cbrown",     // Optional user name.
  Password: "snoopy",     // Optional user password.
}

sess, err = db.Open("mysql", settings)
```

[1]: https://github.com/go-sql-driver/mysql
[2]: http://www.mysql.com
