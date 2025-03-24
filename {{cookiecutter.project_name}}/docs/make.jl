using {{ cookiecutter.project_name.replace('.jl', '') }}
using Documenter
import Pkg


PROJECT_TOML = Pkg.TOML.parsefile(joinpath(@__DIR__, "..", "Project.toml"))
VERSION = PROJECT_TOML["version"]
NAME = PROJECT_TOML["name"]
AUTHORS = join(PROJECT_TOML["authors"], ", ") * " and contributors"
GITHUB = "https://github.com/{{ cookiecutter.github_org }}/{{ cookiecutter.project_name }}"

println("Starting makedocs")

PAGES = ["Home" => "index.md",]

makedocs(;
    authors = "Michael Goerz <mail@michaelgoerz.net> and contributors",
    sitename = "{{ cookiecutter.project_name }}",
    format = Documenter.HTML(;
        prettyurls = true,
        canonical = "https://{{ cookiecutter.github_org }}.github.io/{{ cookiecutter.project_name }}",
        edit_link = "master",
        footer = "[$NAME.jl]($GITHUB) v$VERSION docs powered by [Documenter.jl](https://github.com/JuliaDocs/Documenter.jl).",
        assets = String[],
    ),
    pages = PAGES,
)

println("Finished makedocs")

deploydocs(; repo = "github.com/{{ cookiecutter.github_org }}/{{ cookiecutter.project_name }}", devbranch = "master", push_preview = true)
