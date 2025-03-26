# {{ cookiecutter.project_name }}


```@eval
using Markdown
using Pkg

VERSION = Pkg.dependencies()[Base.UUID("{{ cookiecutter.uuid }}")].version

github_badge = "[![Github](https://img.shields.io/badge/{{  cookiecutter.owner }}-{{ cookiecutter.project_name  }}-blue.svg?logo=github)](https://github.com/{{ cookiecutter.owner }}/{{ cookiecutter.project_name }})"

version_badge = "![v$VERSION](https://img.shields.io/badge/version-v$(replace("$VERSION", "-" => "--"))-green.svg)"

Markdown.parse("$github_badge $version_badge")
```

Documentation for [{{ cookiecutter.project_name.replace('.jl', '') }}](https://github.com/{{ cookiecutter.owner }}/{{ cookiecutter.project_name }}).
