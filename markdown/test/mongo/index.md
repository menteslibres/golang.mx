# upper.io/db/mongo

The `upper.io/db/mongo` adapter for [MongoDB][3] makes use of the
`labix.org/v2/mgo` package by [Gustavo Niemeyer][1].

## Installation

If you want to install the package with `go get`, you'll need the [bazaar][2]
VCS.

You can install `bzr` like this:

```sh
sudo apt-get install bzr -y
```

After bazaar is installed, use `go get` to download and install the adapter.

```go
go get upper.io/db/mongo
```

## Usage

To use this adapter, import `upper.io/db` and the `upper.io/db/mongo` packages.
Note that the adapter must be imported to the [blank identifier][2].

```go
# main.go
package main

import (
  "upper.io/db"
  _ "upper.io/db/mongo"
)
```

Then, you can use the `db.Open()` method to connect to a MongoDB server:

```go
var settings = db.Settings{
  Host:     "localhost",  // MongoDB server IP or name.
  Database: "peanuts",    // Database name.
  User:     "cbrown",     // Optional user name.
  Password: "snoopy",     // Optional user password.
}

sess, err = db.Open("mongo", settings)
```

[1]: http://labix.org/v2/mgo
[2]: http://bazaar.canonical.com/en/
[3]: http://www.mongodb.org/
