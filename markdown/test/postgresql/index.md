# upper.io/db/postgresql

The `upper.io/db/postgresql` adapter for [PostgreSQL][2] is based on the
`github.com/lib/pq` package by [Blake Mizerany][1].

## Installation

Use `go get` to download and install the adapter:

```go
go get upper.io/db/postgresql
```

## Usage

To use this adapter, import `upper.io/db` and the `upper.io/db/postgresql`
packages.  Note that the adapter must be imported to the [blank identifier][2].

```go
# main.go
package main

import (
  "upper.io/db"
  _ "upper.io/db/postgresql"
)
```

Then, you can use the `db.Open()` method to connect to a PostgreSQL server:

```go
var settings = db.Settings{
  Host:     "localhost",  // PostgreSQL server IP or name.
  Database: "peanuts",    // Database name.
  User:     "cbrown",     // Optional user name.
  Password: "snoopy",     // Optional user password.
}

sess, err = db.Open("postgresql", settings)
```

[1]: https://github.com/lib/pq
[2]: http://www.postgresql.org/
