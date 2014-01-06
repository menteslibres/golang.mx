# upper.io/db

The `upper.io/db` project is a [Go][2] package with the ability to communicate
with different kinds of database servers.

This package is able to perform the most common operations on SQL and NoSQL
databases such as creating, searching, updating and removing items through the
use of special subpackages, known as **adapters**.

This is the documentation site, you can also see the [source code
repository][7] at [github][7].

## Required software

The `upper.io/db` package depends on the [Go compiler and tools][4], of course.
[Version 1.1+][5] is required since the underlying `mgo` driver for the `mongo`
adapter depends on a method (`reflect.Value.Convert`) introduced in go1.1.
However, using a lower Go version (down to go1.0.1) could still be possible
with other adapters.

In order to use `go get` you'll also need the [git][3] version control system.
You can install `git` on a Debian-based system like this:

```sh
sudo apt-get install git -y
```

### Getting the package

You can download and install the `upper.io/db` package using `go get`:

```sh
go get upper.io/db
```

*Note:* If the `go get` program fails with something like:

```sh
package upper.io/db: exec: "git": executable file not found in $PATH
```

it means that a required program is missing, `git` in this case. To overcome
this error install the missing application and try again.

## Database adapters

Installing the main package just provides base datatypes and interfaces, but in
order to communicate with a database you'll also need a database adapter.

Here's a list of available database adapters. Look into the adapter's link to
see installation instructions that are specific to each adapter.

* [SQLite 3](./db/sqlite/)
* [MySQL](./db/mysql/)
* [PostgreSQL](./db/postgresql)
* [MongoDB](./db/mongo)

## Learn by example

Through this example, we'll be featuring the SQLite3 database and the `sqlite`
adapter.

Fire up a terminal and check if the `sqlite3` command is installed. If the
program is missing install it like this:

```go
# Installing sqlite3 in Debian
sudo apt-get install sqlite3 -y
```

Then, run the sqlite3 command and create a `test.db` database:

```sh
sqlite3 test.db
```

The sqlite3 program will welcome you with a prompt, like this:

```
sqlite>
```

From within the sqlite3 prompt, create a demo table:

```sql
CREATE TABLE demo (
  first_name VARCHAR(80),
  last_name VARCHAR(80),
  bio TEXT
);
```

After creating the table, type `.exit` to end the sqlite3 session.

```
sqlite> .exit
```

Now you're ready to code. Create a `main.go` file and import both the
`upper.io/db` and the recently installed adapter `upper.io/db/sqlite`:

```go
# main.go
package main

import (
  "upper.io/db"
  _ "upper.io/db/sqlite"
)
```

Then, configure the database credentials using the `db.Settings` struct. This
struct is used to store authentication settings that `db.Open` will use to
connect to a database:

```go
// Connection and authentication data.
type Settings struct {
  // Host to connect to. Cannot be used if Socket is specified.
  Host string
  // Port to connect to. Cannot be used if Socket is specified.
  Port int
  // Name of the database to use.
  Database string
  // Authentication user name.
  User string
  // Authentication password.
  Password string
  // A path of a UNIX socket. Cannot be user if Host is specified.
  Socket string
  // Charset of the database.
  Charset string
}
```

In this example we'll be using an authentication-less sqlite3 database so most
`db.Settings` fields like `User`, `Password` or `Hostname` are not required:

```go
# main.go
var settings = db.Settings{
  Database: `example.db`,
}
```

After configuring the database settings create a `main()` function and use
`db.Open()` inside. This method creates a connection to a database using an
adapter. The first argument is the name of the adapter (`upper.io/db/$NAME`),
the second one is a `db.Settings` variable, such as the `settings` we've
created above.

```go
sess, err = db.Open("sqlite", settings)
```

Now you can use the `sess` variable to get a `db.Collection` reference.

## Working with collections

In order to use and query collections you'll need a collection reference, use
the `db.Database.Collection()` method on the previously defined `sess` variable
to get a collection reference:

```go
// Pass the table/collection name to get a collection reference.
col, err = sess.Collection("demo")
```

Try to use the collection reference to insert a new row into the database:

```go
item = map[string]interface{}{
  "first_name": "Hayao",
  "last_name": "Miyazaki",
  "bio": "Japanese film director.",
}
col.Append(item)
```

Using structs to define the format of collection items is not strictly required
(we could use maps too), but it is recommended. If you'd like to create a
struct datatype for the demo table we've created before, then you should define
each column as a field of the struct:

```go
type Demo struct {
  FirstName string `field:"first_name"`
  LastName string `field:"last_name"`
  Bio string `field:"bio"`
}
```

And instead of using a map, we can insert a `Demo{}` value with the
`db.Collection.Append()` call.

```go
item = Demo{
  "Hayao",
  "Miyazaki",
  "Japanese film director.",
}
col.Append(item)
```

If you have followed the example until here, then you should have a snippet
that looks like this:

```go
# main.go

package main

import (
  "upper.io/db"
  _ "upper.io/db/sqlite"
)

var settings = db.Settings{
  Database: "test.db",
}

type Demo struct {
  FirstName string `field:"first_name"`
  LastName string `field:"last_name"`
  Bio string `field:"bio"`
}

func main() {
  sess, err := db.Open("sqlite", settings)

  if err != nil {
    panic(err.Error())
  }

  col, err := sess.Collection("demo")

  col.Append(Demo{
    "Hayao",
    "Miyazaki",
    "Japanese film director.",
  })

  if err != nil {
    panic(err.Error())
  }
}
```

compile and run it, like this:

```sh
go build main.go
./main
```

## Working with result sets

You can use the `db.Collection.Find()` method to search for the recently
appended item. This method creates a result set, this result set can then be
iterated or dumped to a pointer or a pointer to slice.

```go
res = col.Find(db.Cond{"last_name": "Miyazaki"})
```

Once you have a result set (`res` in this example), you can choose to fetch
results into a slice, providing a pointer to a slice of structs or maps, as in
the following example.

```go
var birthdays []Birthday
err = res.All(&birthdays)
```

Filling a slice could be expensive if you're working with a lot of rows, if you
need to optimize memory usage for big result sets looping over the result set
could be better, use `db.Result.Next()` to fetch one row at a time.

```go
var birthday Birhday
for {
  err = res.Next(&birthday)
  if err == nil {
    // No error happened.
  } else if err == db.ErrNoMoreRows {
    // Natural end of the result set.
    break;
  } else {
    // Another kind of error, should be taken care of.
    return res
  }
}
```

If you need only one element of the result set, the `db.Result.One()` method
could be better suited for the task.

```go
var birthday Birhday
err = res.One(&birthday)
```

## Narrowing result sets

Once you have a basic understanding of result sets, you can start using
conditions and limits to reduce the amount of rows returned in a query.

Use the `db.Cond{}` type to define conditions for `db.Collection.Find()`.

```go
res = col.Find(db.Cond{"user_id": 1})
```

If you want to add multiple conditions just provide more keys to the
`db.Cond{}` map:

```go
res = col.Find(db.Cond{
  "user_id": 1,
  "email": "user@example.org",
})
```

provided conditions will be grouped under an *AND* conjunction.

If you want to use an *OR* disjunction instead, the `db.Or{}` type is also
available. The following code:

```go
res = col.Find(db.Or{
  db.Cond{
    "email": "user@example.org",
  },
  db.Cond{
    "email": "user@example.com",
  }
})
```

means `(email = "user@example.org" OR email = "user@example.com")`.

Complex *AND* filters can be delimited by the `db.And{}` type.

This example:

```go
res = col.Find(db.And{
  db.Or{
    db.Cond{
      "first_name": "Jhon",
    },
    db.Cond{
      "first_name": "John",
    },
  },
  db.Or{
    db.Cond{
      "last_name": "Smith",
    },
    db.Cond{
      "last_name": "Smiht",
    },
  },
})
```

means `(first_name = "Jhon" OR first_name = "John") AND (last_name = "Smith" OR
last_name = "Smiht")`.

The resulting result set can be delimited using `db.Result.Limit()` and
`db.Result.Skip()` or sorted by value, using the `db.Result.Sort()` function.

This example:

```go
res = col.Find().Skip(10).Limit(8).Sort("-name")
```

skips ten rows, counts up to eight rows and sorts the results by name
(descendent).

If you want to know how many rows the query is returning, use the
`db.Result.Count()` call.

```go
c, err := res.Count()
```

When you're done using the result set, remember to close it.

```go
res.Close()
```

## More operations with result sets

Result sets are not only capable of returning rows, they can also be used to
update or delete all the rows within the given conditions.

If you want to update the whole set of rows you can use the
`db.Result.Update()` method.

```go
res = col.Find(db.Cond{"name": "Old name"})

err = res.Update(map[string]interface{}{
  "name": "New name",
})
```

If you want to delete a set of rows, use the `db.Result.Remove()` call on a
result set.

```go
res = col.Find(db.Cond{"active": 0})

res.Remove()
```

## Closing result sets

Make sure to use `db.Result.Close()` when finishing using the result set.

```go
res.Close()
```

## Working with databases

There are many more things you can do with a `db.Database` reference besides
getting a collection.

For example, you could get a list of all collections within the database:

```go
all, err = sess.Collections()
for name := range all {
  fmt.Printf("Got collection %s.\n", name)
}
```

If you ever need to connect to another database, you can use the
`db.Database.Use` method

```go
err = sess.Use("another_database")
```

## Tips and tricks

### Transactions

If the database server you're using supports transactions, you can use the
`db.Database.Begin()` and `db.Database.End()` methods to delimit transactions:

```go
sess.Begin()
col.Append(item)
...
col.Append(item)
sess.End()
```

### Working with the underlying driver

Some situations will require you to use methods that are specific to the
underlying driver, for example, if you're in the need of using the
[mgo.Session.Ping](http://godoc.org/labix.org/v2/mgo#Session.Ping) method, you
can retrieve the underlying `*mgo.Session` as an `interface{}`, cast it with
the appropriate type and use the `mgo.Session.Ping()` method on it, like this:

```go
drv = sess.Driver().(*mgo.Session)
err = drv.Ping()
```

## Method reference

You can see the [full method reference][6] for `upper.io/db` at [godoc.org][6].

## How to contribute

Thanks for taking the time to contribute. There are many ways you can help this
project:

### Reporting bugs and suggestions

The [source code page][7] at github includes a nice [issue tracker][8], please
use this interface to report bugs.

### Hacking the source

The [source code page][7] at github includes a nice [issue tracker][8], see the
issues or create one, then [create a fork][11], hack on your fork and when
you're done create a [pull request][12], so that the code contribution can get
merged into the main package. Note that not all contributions can be merged to
`upper.io/db`, so please be very explicit on how the package users can get the
greater benefit from your hack.

### Improving the documentation

There is a special [documentation repository][9] at github were you can also
file [issues][10]. If you find any spot were you would like the docs to be more
specific, please open an issue to let us know; and if you're in the possibility
of helping us fixing grammar errors, typos, code examples or even documentation
issues, please [create a fork][11], edit the documentation files and then
create a [pull request][12], so that the contribution can be merged into the
main repository.

## License

The MIT license:

> Copyright (c) 2013 José Carlos Nieto, https://menteslibres.net/xiam
>
> Permission is hereby granted, free of charge, to any person obtaining
> a copy of this software and associated documentation files (the
> "Software"), to deal in the Software without restriction, including
> without limitation the rights to use, copy, modify, merge, publish,
> distribute, sublicense, and/or sell copies of the Software, and to
> permit persons to whom the Software is furnished to do so, subject to
> the following conditions:
>
> The above copyright notice and this permission notice shall be
> included in all copies or substantial portions of the Software.
>
> THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
> EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
> MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
> NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE
> LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION
> OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION
> WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

[1]: http://upper.io
[2]: http://golang.org
[3]: http://git-scm.com/
[4]: http://golang.org/doc/install
[5]: http://golang.org/doc/go1.1
[6]: http://godoc.org/upper.io/db
[7]: https://github.com/upper/db
[8]: https://github.com/upper/db/issues
[9]: https://github.com/upper/db-docs
[10]: https://github.com/upper/db-docs/issues
[11]: https://help.github.com/articles/fork-a-repo
[12]: https://help.github.com/articles/fork-a-repo#pull-requests
