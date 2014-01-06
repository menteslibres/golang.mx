# SQLite adapter for upper.io/db

The `upper.io/db/sqlite` adapter for the [SQLite3 database][3] is based on the
`github.com/mattn/go-sqlite3` package by [Yasuhiro Matsumoto][1].

## Installation

This package makes use of cgo, so in order to compile and install it you'll
also need a C compiler, like `gcc`:

```go
apt-get install gcc
```

Otherwise, you'll end with an error like this:

```
# github.com/xiam/gosqlite3
exec: "gcc": executable file not found in $PATH
```

Once `gcc`is installed, use `go get` to download, compile and install the
sqlite adapter.

```go
go get upper.io/db/sqlite
```

## Usage

To use this adapter, import `upper.io/db` and the `upper.io/db/sqlite`
packages. Note that the adapter must be imported to the [blank identifier][2].

```go
# main.go
package main

import (
  "upper.io/db"
  _ "upper.io/db/sqlite"
)
```

Then, you can use the `db.Open()` method to open a SQLite3 database file:

```go
var settings = db.Settings{
  Database: `/path/to/example.db`, // Path to a sqlite3 database file.
}

sess, err = db.Open("sqlite", settings)
```

[1]: https://github.com/mattn/go-sqlite3
[2]: http://golang.org/doc/effective_go.html#blank
[3]: http://www.sqlite.org/
[]
[]
