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

Finalmente, los comentarios dentro de bloques de terminal comienzan con un
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
donde se descargó el paquete y lo descomprimimos al directorio `/usr/local`
(con permisos de administrador o como *root*).

```sh
$ cd ~/Downloads
$ ls go1.1.1.linux-amd64.tar.gz
$ sudo tar -C /usr/local -xzvf go1.1.linux-amd64.tar.gz
...
```

Ahora comprobamos que el programa `go` funciona llamándolo con su ruta completa:

```sh
$ /usr/local/go/bin/go version
go version go1.1.1
```

Si tenemos una respuesta similar a `go version go1.1.1` podemos concluir que [Go][1]
está correctamente instalado.

Eso ha sido sencillo :).

## Variables de entorno

Ahora que ya tienes las herramientas de [Go][1] instaladas probablemente creas
que escribir la ruta completa `/usr/local/go/bin/go` puede ser un poco incómodo,
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
`:/usr/local/go/bin` que es donde sabemos se encuentra el comando `go`.

```sh
# Exportamos
$ export PATH=$PATH:/usr/local/go/bin
# Ejecutamos go
$ go version
go version go1.1.1
```

Este valor de `$PATH` se cambia de manera temporal, si cierras la terminal
o abres otra habrá que repetir el comando `export`.

## Ejecutando y compilando tu primer programa en Go

En la misma terminal intentemos crear un programa de `go`. Guardemos el
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

Haremos nuestra primera prueba haciendo que go interprete el script que acabamos de
crear:

```sh
$ go run hello.go
Hello world!
```

También podemos utilizar `go build hello.go` para compilarlo:
```sh
$ go build hello.go
```

Esto creará un ejecutable de nombre "hello". Escribamos `./hello` para ejecutarlo:

```sh
# Compilamos
$ go build hello.go
# Revisamos se haya creado un binario usando el comando file
$ file hello
hello: ELF 64-bit LSB  executable, x86-64, version 1 (SYSV), statically linked, not stripped
# Ejecutamos
$ ./hello
Hello world!
```

¡Muy bien! Has ejecutado y compilado tu primer programa en [Go][1] utilizando
[*go tools*][4], continúa el tutorial sin cerrar la terminal en la que estás.

## Trabajando con `go tools` y $GOPATH

Uno de los principales comandos de [Go][1] es `go get`.

`go get` te permite descargar e instalar librerías o programas hospedados en
servicios populares como <http://launchpad.net>, <http://github.com>,
<http://code.google.com>, etc. utilizando sistemas de control de versiones como
`git`, `bzr` o `hg`, entre otros.

Intentemos utilizar `go get` para obtener un paquete de prueba que puedes ver
en la URL <https://github.com/menteslibres/gotestpkg>.

```
$ go get github.com/menteslibres/gotestpkg
package github.com/menteslibres/gotestpkg: cannot download, $GOPATH not set.
For more details see: go help gopath
```

El primer mensaje que nos da `go get` es un error al intentar descargar el paquete.
Una convención utilizada por las herramientas go tools es que deberá tener
establecido un directorio donde se puedan almacenar todos los paquetes
adicionales que se vayan a usar, así como una variable de entorno $GOPATH
apuntándolo. Generalmente se utiliza el directorio `$HOME/go` o `~/go`, a
continuación crearemos dicho directorio, así como también definiremos $GOPATH:

```sh
# Creamos el directorio $HOME/go.
$ mkdir ~/go
# Dentro del nuevo directorio creamos los
# subdirectorios "bin", "pkg" y "src".
$ mkdir ~/go/bin
$ mkdir ~/go/pkg
$ mkdir ~/go/src
# o si lo prefieres, en una sola línea...
# mkdir -p ~/go/{bin,pkg,src}
# Definimos la variable $GOPATH que será utilizada
# por go tools.
$ export GOPATH=$HOME/go
# Agregamos otro elemento a $PATH, nuestro $GOPATH/bin.
$ export PATH=$PATH:$GOPATH/bin
```

Ahora intentemos el mismo ejemplo:

```sh
$ go get github.com/menteslibres/gotestpkg
$ gotestpkg
Hello world!
```

¡Funciona!

Observa que además de obtener y compilar el ejemplo, `go get` también copió
el ejecutable a `$GOPATH/bin`:

```sh
$ ls $GOPATH/bin
gotestpkg
```

Y podemos ejecutarlo por su nombre puesto que `$GOPATH/bin` ya es parte de
`$PATH`.

## Hacer cambios permanentes al entorno de trabajo

Las variables de sistema definidas con `export` sólo son válidas en la
terminal actual. Para hacerlas válidas en cualquier terminal que abramos
es necesario agregarlas al archivo de inicialización de nuestra *shell*.

Para saber cuál *shell* tienes ejecuta:

```sh
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
es abrir `~/.bashrc` con un editor de texto (por ejemplo usando: `nano ~/.bashrc`)
 y agregar las siguientes líneas al final del archivo:

```sh
# ¿Donde están las go tools?
export GOROOT=/usr/local/go
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
go version go1.1.1 linux/amd64
$ echo $GOROOT
/usr/local/go
$ echo $GOPATH
/home/gouser/go
```

Con esto se termina la primer instalación de [Go][1] :-).

Puedes continuar con [How to write Go Code][6] y al término seguir con
[Effective Go][5].

## Alternativas de instalación

También se pueden usar los instaladores según el sistema operativo: en
Microsoft Windows (extensión `.msi`) o para Mac OSX (extensión `.pkg`).
A la fecha [Go][1] ya se está integrando a las distribuciones de Linux/BSD
 a través de sus administradores de paquetes: apt-get, yum, pkg_add, etc.
 Deberías tomar en cuenta que quizás tengas que incluir las variables $GOPATH y
$GOROOT mencionadas en éste tutorial.

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
