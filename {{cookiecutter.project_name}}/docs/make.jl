using {{ cookiecutter.project_name.replace('.jl', '') }}
using Documenter
import Pkg


PROJECT_TOML = Pkg.TOML.parsefile(joinpath(@__DIR__, "..", "Project.toml"))
VERSION = PROJECT_TOML["version"]
NAME = PROJECT_TOML["name"]
AUTHORS = join(PROJECT_TOML["authors"], ", ") * " and contributors"
GITHUB = "https://github.com/{{ cookiecutter.owner }}/{{ cookiecutter.project_name }}"

println("Starting makedocs")

PAGES = ["Home" => "index.md", "API" => "api.md"]

makedocs(;
    authors = AUTHORS,
    sitename = "$NAME.jl",
    format = Documenter.HTML(;
        prettyurls = true,
        canonical = "https://{{ cookiecutter.owner }}.github.io/{{ cookiecutter.project_name }}",
        edit_link = "master",
        footer = "[$NAME.jl]($GITHUB) v$VERSION docs powered by [Documenter.jl](https://github.com/JuliaDocs/Documenter.jl).",
        assets = String[],
    ),
    pages = PAGES,
)

println("Finished makedocs")

# The documentation is deployed by `docs/deploy.jl`, in a separate CI job
