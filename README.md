# golang.mx

Código fuente del sitio del [grupo de usuarios Go en México][1].

## Instalación

Antes de instalar, asegúrate de tener [Go](http://golang.org).

```
$ go version
go version go1.0.3
```

Ahora [descarga][2] o compila *Luminos*.

```
$ go get menteslibres.net/luminos
```

Clona el repo a `~/projects/golang.mx`, si deseas puedes usar la URL de tu fork
o jugar con `git remote`. Estas instrucciones suponen que se utiliza un fork.

```
$ cd ~/projects
$ go get git@github.com:menteslibres/golang.mx.git
...
Resolving deltas: 100% (3/3), done.
```

El proyecto incluye un `settings.yaml` que puede ser cargado por [Luminos][3],
esta configuración pondrá a Luminos en modo *standalone*, por lo que no será
necesario un servidor web adicional.

```
$ cd ~/projects/golang.mx
$ ls
markdown/  README.md  settings.yaml  site.yaml  templates/  webroot/
$ luminos -c settings.yaml run
...
2013/04/13 04:30:27 Routing: default -> .
2013/04/13 04:30:27 Starting HTTP server. Listening at 127.0.0.1:9100.
```

Finalmente, abre [127.0.0.1:9100](http://127.0.0.1:9100) en tu navegador
preferido y
[resuelve una tarea](https://github.com/menteslibres/golang.mx/issues).

[1]: http://golang.mx
[2]: https://menteslibres.net/luminos/download
[3]: https://menteslibres.net/luminos

> Copyright (c) 2013 Autores de golang.mx.
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
