<!doctype html>
<html>
  <head>
    <link rel="stylesheet" href="/styles.css" type="text/css" />

    {{ if .IsHome }}
        <title>{{ setting "page/head/title" }}</title>
    {{ else }}
      {{ if .Title }}
        <title>
          {{ .Title }} {{ if setting "page/head/title" }} // {{ setting "page/head/title" }} {{ end }}</title>
      {{ else }}
        <title>{{ setting "page/head/title" }}</title>
      {{ end }}
    {{ end }}

    <script src="//ajax.googleapis.com/ajax/libs/jquery/1.9.1/jquery.min.js"></script>

    <link rel="stylesheet" href="//menteslibres.net/static/highlightjs/styles/solarized_dark.css">
    <script src="//menteslibres.net/static/highlightjs/highlight.pack.js"></script>

    <script src="//menteslibres.net/luminos/js/main.js"></script>
  </head>
  <body>
    <header>
      <h1>
        <a id="title" href="{{ url "/" }}"><span>{{ setting "page/brand" }}</span></a>
      </h1>
      <nav>
        {{ if settings "page/body/menu" }}
          {{ range settings "page/body/menu" }}
            <a href="{{ .url }}" class="fade">{{ .text }}</a>
          {{ end }}
        {{ end }}
      </nav>
    </header>

    {{ if .IsHome }}

      <section class="intro">
        <div class="gophers"></div>
        <span class="hashtag">
          <a href="https://twitter.com/search?q=%23golangmx&src=hash" class="fade">#golangmx</a>
        </span>
      </section>

      <section class="calendar">
        <p>¿Te interesa aprender o practicar Go? ¡Estemos en contacto!</p>
      </section>
      <section class="contribute">
        <h2>Contribuye</h2>
        <p>Contribuir es sencillo</p>
        <ul>
          <li>
            <div class="step fork"></div>
            <p>Haz un <a target="_blank" href="https://github.com/menteslibres/golang.mx">fork</a></p>
          </li>
          <li>
            <div class="step luminos"></div>
            <p>Instala <a target="_blank" href="https://menteslibres.net/luminos">luminos</a> para poder ver tu versión local de golang.mx</p>
          </li>
          <li>
            <div class="step tasks"></div>
            <p>Revisa las <a target="_blank" href="https://github.com/menteslibres/golang.mx/issues">tareas pendientes</a> y elige una</p>
          </li>
          <li>
            <div class="step pull"></div>
            <p>Resuelve la tarea en tu fork  y manda <a target="_blank" href="https://help.github.com/articles/creating-a-pull-request">pull request</a></p>
          </li>
        </ul>
        <p class="doubts">
          Si tienes dudas pregunta en la comunidad de <a target="_blank" href="https://plus.google.com/communities/110325783890611262108">Go+ México</a> o a
          <a target="_blank" href="https://twitter.com/golangmx">@golangmx</a>.
        </p>
      </section>
    {{ else }}
      <section class="content">
        {{ if .SideMenu }}
          {{ if .Content }}
            <aside>
              <ul class="nav nav-list menu">
                {{ range .SideMenu }}
                  <li>
                    <a href="{{ url .link }}">{{ .text }}</a>
                  </li>
                {{ end }}
              </ul>
            </aside>
            <div class="main-content">
              {{ .ContentHeader }}

              {{ .Content }}

              {{ .ContentFooter }}
            </div>
          {{ else }}
            <div class="main-content">
              {{ if .CurrentPage }}
                <h1>{{ .CurrentPage.text }}</h1>
              {{ end }}
                <ul class="nav nav-list menu">
                  {{ range .SideMenu }}
                    <li>
                      <a href="{{ url .link }}">{{ .text }}</a>
                    </li>
                  {{ end }}
                </ul>
            </div>
          {{ end }}
          {{ else }}
          <div class="main-content full">
            {{ .ContentHeader }}

            {{ .Content }}

            {{ .ContentFooter }}
          </div>
        {{ end }}
      </section>

    {{ end }}

    <footer>
      <a href="https://github.com/menteslibres/golang.mx" target="_blank">¿Quieres hackear éste sitio?</a>
    </footer>

    {{ if setting "page/body/scripts/footer" }}
      <script type="text/javascript">
        {{ setting "page/body/scripts/footer" | jstext }}
      </script>
    {{ end }}
  </body>
</html>
