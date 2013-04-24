# ¿Cómo instalar Go?

## Introducción

Utilizaremos la terminal del sistema. Para Linux/*BSD existen muchas opciones
y probablemente ya tengas una favorita, para Mac OSX la terminal que se incluye
es la aplicación `Terminal`, si estás en Windows te recomendamos ver la
alternativa de instalación mediante un paquete `.msi` y practicar éste tutorial
en una máquina virtual con Linux.

Para hacer el tutorial más accesible se intenta explicar el significado de
cada paso. Dependiendo de tu experiencia puedes saltar explicaciones.

### Formato del tutorial

Los comandos que se mandarán a la terminal comienzan con un símbolo `$`. Por
ejemplo veamos el siguiente bloque:

```
$ echo hola
hola
```

El bloque de arriba indica mandar a terminal la instrucción `echo hola`. Observa
que no se debe considerar el símbolo `$` como parte del comando y que la
respuesta del comando `hola` no tiene un símbolo `$`.

Finamente, los comentarios dentro de bloques de terminal comienzan con un
símbolo `#`.

```
# Vamos a imprimir "hola"
$ echo hola
hola
```

## Obtención del paquete

El primer paso es obtener el compilador de [Go][1] apropiado para el sistema en
que se planea utilizar. El compilador se descarga de la
[página del proyecto Go][3] en `code.google.com`.

Como puedes observar, existen varios paquetes disponibles para descargar,
escoge el más apropiado para tu sistema (de los que terminan con extensión
`.tar.gz`).

Al terminal la descarga abrimos una terminal, nos ubicamos en el directorio
donde se descargó el paquete y lo descomprimimos al directorio `/usr/lib`
(con permisos de administrador o como *root*).

```sh
$ cd ~/Downloads
$ ls go1.0.3.linux-amd64.tar.gz
$ sudo tar -xvzf go1.0.3.linux-amd64.tar.gz -C /usr/lib
...
```

Ahora comprobamos que el programa `go` funciona llamándolo con su ruta completa:

```sh
$ /usr/lib/go/bin/go version
go version go1.0.3
```

Si tenemos una respuesta como `go version go1.0.3` podemos concluir que [Go][1]
está correctamente instalado.

Eso ha sido sencillo :).

## Variables de entorno, $GOPATH y $GOROOT.

Ahora que ya tienes las herramientas de [Go][1] instaladas probablemente creas
que escribir la ruta completa `/usr/lib/go/bin/go` puede ser un poco incómodo,
sería más sencillo invocar el programa `go` sólo por su nombre:

```sh
$ go
zsh: command not found: go
```

Sin embargo a primera vista no funciona, esto es por que el binario `go` no
se encontró en alguna de las rutas de búsqueda de comandos del sistema. Para
que ésto funcione necesitamos agregar la ruta de los binarios de [Go][1] a la
variable de entorno `$PATH`.

Utilizamos el comando `export` para agregar a la variable `$PATH` el valor
`:/usr/lib/go/bin` que es donde sabemos se encuentra el comando `go`.

```sh
# Exportamos
$ export PATH=$PATH:/usr/lib/go/bin
# Ejecutamos go
$ go
go version go1.0.3
```

Este valor de `$PATH` se cambia de manera temporal, si cierras la terminal
o abres otra habrá que repetir el `export`.

En la misma terminal intentemos compilar un programa de `go`. Guardemos el
código siguiente como `~/tmp/hello.go`

```go
# Archivo: ~/tmp/hello.go

package main

import (
  "fmt"
)

func main() {
  fmt.Printf("Hello world!\n")
}
```

Cambiemos al directorio `~/tmp` en nuestra terminal, donde guardamos `hello.go`.

```
$ cd ~/tmp
```

Utilicemos `go build hello.go` para compilarlo, esto creará un ejecutable de
nombre "hello". Escribamos `./hello` para ejecutarlo:

```sh
$ go build hello.go
$ file hello
hello: ELF 64-bit LSB  executable, x86-64, version 1 (SYSV), statically linked, not stripped
$ ./hello
Hello world!
```

¡Muy bien! Has compilado tu primer programa en [Go][1] utilizando
[*go tools*][4], continua el tutorial sin cerrar la terminal en la que estás.

## Trabajando con `go tools`

Uno de los principales comandos de [Go][1] es `go get`.

`go get` te permite descargar e instalar librerías o programas hospedados en
servicios populares como <http://launchpad.net>, <http://github.com>,
<http://code.google.com>, etc. utilizando sistemas de control de versiones como
`git`, `bzr` o `hg`, entre otros.

Intentemos utilizar `go get` para obtener un paquete de prueba que puedes ver
en la URL <https://github.com/menteslibres/gotestpkg>.

```
$ go get github.com/menteslibres/gotestpkg
package github.com/menteslibres/gotestpkg: mkdir /usr/lib/go/site/src: permission denied
```

El primer mensaje que nos da `go get` es un permiso denegado para modificar el
contenido de `/usr/lib/go/site/src`, esto es correcto, un usuario normal no
tiene permisos suficientes para modificar `/usr/lib/`. Lo que tenemos que hacer
es definir un directorio del usuario donde *go tools* pueda guardar lo que
necesita, por convención utilicemos `$HOME/go` o `~/go`.

```sh
# Creamos el directorio $HOME/go.
$ mkdir ~/go
# Dentro del nuevo directorio creamos los
# subdirectorios "bin", "pkg" y "src".
$ mkdir ~/go/bin
$ mkdir ~/go/pkg
$ mkdir ~/go/src
# Definimos la variable $GOPATH que será utilizada
# por go tools.
$ export GOPATH=$HOME/go
# Agregamos otro elemento a $PATH, nuestro $GOPATH/bin.
$ export PATH=$PATH:$GOPATH/bin
```

Ahora intentemos el mismo ejemplo:

```
$ go get github.com/menteslibres/gotestpkg
$ gotestpkg
Hello world!
```

¡Funciona!

Observa que además de obtener y compilar el ejemplo, `go get` también copió
el ejecutable a `$GOPATH/bin`:

```
$ ls $GOPATH/bin
gotestpkg
```

Y podemos ejecutarlo por su nombre puesto que `$GOPATH/bin` ya es parte de
`$PATH`.

## Hacer cambios a entorno permanentes

Las variables de sistema definidas con `export` sólo son válidas en la
terminal actual. Para hacerlas válidas en cualquier terminal que abramos
es necesario agregarlas al archivo de inicialización de nuestra *shell*.

Para saber cuál *shell* tienes ejecuta:

```
$ echo $SHELL
/usr/bin/zsh
```

Los valores más comunes pueden ser `/usr/bin/bash`, `/usr/bin/sh`,
`/usr/bin/zsh`, etc.

Dependiendo el nombre de tu shell el archivo de inicio es el que se menciona:

* `/usr/bin/zsh`, para zsh: `$HOME/.zshrc`
* `/usr/bin/bash`, para bash: `$HOME/.bashrc`
* `/usr/bin/sh`, para sh y otros: `$HOME/.profile`

Supongamos que tu archivo de inicio es `$HOME/.bashrc`, lo que debemos hacer
es abrir `~/.bashrc` con un editor de texto y agregar las siguientes líneas al
final del archivo:

```sh
# ¿Donde están las go tools?
export GOROOT=/usr/lib/go
# ¿Cuál es nuestro directorio local de Go?
export GOPATH=$HOME/go
# Modificamos $PATH por comodidad.
export PATH=$GOROOT/bin:$GOPATH/bin
```

Si el archivo no existe puedes crearlo.

La manera más fácil de comprobar que las variables de entorno son correctas
es abrir otra terminal y ejecutar `go version`.

```
$ go version
go version go1.0.3
$ echo $GOROOT
/usr/lib/go
$ echo $GOPATH
/home/gouser/go
```

Con esto se termina la primer instalación de [Go][1] :-).

Puedes continuar con [How to write Go Code][6] y al término seguir con
[Effective Go][5].

## Alternativa de instalación

La alternativa más rápida es utilizar el instalador para Windows
(extensión `.msi`) o para OSX (extensión `.pkg`), utilizar un instalador se
recomienda cuando ya se entiende el concepto de `$GOPATH` y `$GOROOT`.

## Lecturas recomendadas

* [How to write Go code][6].
* La [referencia de instalación][2] de [Go][1].
* Referencia del comando `go` y [go tools][4].
* [Effective Go][4].

## Amplia éste tutorial

El tutorial puede ampliarse o corregirse mediante un *pull request*, el
repositorio está [abierto](https://github.com/menteslibres/golang.mx) en github.

[1]: http://golang.org
[2]: http://golang.org/doc/install
[3]: https://code.google.com/p/go/downloads/list
[4]: http://golang.org/cmd/go/
[5]: http://golang.org/doc/effective_go.html
[6]: http://golang.org/doc/code.html
