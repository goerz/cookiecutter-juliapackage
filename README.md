# Cookiecutter Template for Julia Projects

## Prerequisites

* A Unix-based operating system (your mileage may vary on Windows)
* [`cookiecutter`](https://github.com/cookiecutter/cookiecutter) (`pipx install cookiecutter`, see the [installation instructions](https://github.com/cookiecutter/cookiecutter?tab=readme-ov-file#installation))
* A GitHub account [authenticated with SSH](https://docs.github.com/en/authentication/connecting-to-github-with-ssh)

The minimum required version of `cookiecutter` is 2.4.0 to support the [pre-prompt scripts](hooks/pre_prompt.py) that generates the UUID for the Julia package.

## Generating a Julia Project

Run

```
cookiecutter gh:goerz/cookiecutter-juliapackage
```

and fill out the required information, following the prompts.

Afterwards,

* create the Project on GitHub. Make sure to match the project name (including the `.jl` suffix!)
* push the project to GitHub (`git push -u origin master`)
* add an SSH Deploy Key on GitHub, for Documenter
  - Install the `DocumenterTools` Julia package into your base environment
  - Open a REPL for the generated project (`make devrepl`)
  - Load both `DocumenterTools` and the generated project (e.g., `MyPackage`)
  - Run, e.g., `DocumenterTools.genkeys(MyPackage)`
  - Follow the instructions printed in the REPL
* enable GitHub Pages (Repository Settings, "Pages"), set "Branch" to `gh-pages`.
* Make sure you have a [`CODECOV_TOKEN`](https://docs.codecov.com/docs/adding-the-codecov-token) set up. This can be set [at the level of an organization](https://discourse.julialang.org/t/psa-new-version-of-codecov-action-requires-additional-setup/109857). For packages hosted by a personal account, the token must be set as a repository secret (and it it best to use a project-specific token).
* Go through the settings of the project on GitHub. Options to enable include "Always suggest updating pull request branches" and "Automatically delete head branches".

## Template Variables

  * `project_name`: The name of the package, including the `.jl` suffix
  * `author`: The name of the author, in the `Project.toml` and `LICENSE` file
  * `email`: The email address under which to reach the author
  * `github_org`: The name of the user or organization hosting the project on GitHub
  * `year`: The year in the copyright notice
  * `version`: The initial version in the `Project.toml`
  * `julia_version`: The minimum supported Julia version
  * `uuid`: The UUID of the project. This should be [auto-generated](https://stackoverflow.com/questions/69945658/how-to-create-a-uuid-for-a-julia-package).

## Features

* `Makefile` for development workflows (see below)
* Test environment configured with `test/Project.toml` (requires Julia 1.11 for the [`[Sources]` section](https://github.com/crate-ci/typos))
* Automated testing on CI
* Documentation via [Documenter](https://documenter.juliadocs.org/stable/)
* Documentation build environment configured with `docs/Project.toml` (requires Julia 1.11 for the [`[Sources]` section](https://github.com/crate-ci/typos))
* Documentation is build on CI and deployed to GitHub Pages
* For pull requests, CI deploys preview documentation and automatically cleans it up
* [CompatHelper](https://github.com/JuliaRegistries/CompatHelper.jl) and [TagBot](https://github.com/JuliaRegistries/TagBot)
* Code coverage with [Codecov](https://about.codecov.io)
* Automatic code style via [JuliaFormatter](https://github.com/domluna/JuliaFormatter.jl), enforced on CI.
* The default branch is `master`, [not `main`](https://docs.github.com/en/account-and-profile/setting-up-and-managing-your-personal-account-on-github/managing-user-account-settings/managing-the-default-branch-name-for-your-repositories)
* Spell-checking with [typos](https://github.com/crate-ci/typos) on CI.
* Versions on `master` must have a `-dev` or `+dev` suffix. Release versions are allowed only on `release-*` branches

## Development

Various development tasks can be achieved via the `Makefile`. Run `make` (or `make help`) for an overview.

Running `make devrepl` opens a development REPL where the tests can be run with `include("test/runtests.jl")` and the documentation can be built using `include("docs/make.jl")`.
