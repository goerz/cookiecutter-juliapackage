# Contributing

Everyone is welcome to contribute! You can contribute via simply opening Issues reporting bugs or requesting features.

## Pull Request Contributions

The best way to contribute is by doing a Pull Request that fixes a bug or implements a new feature.

However, before opening the PR, consider first discussing the change you wish to make via an issue, so that a good design can be discussed.

To make a good PR, follow these steps:

1. Add adequate description in the Pull Request, or cite the corresponding issue if one exists by using `#` and the issue number.
2. Ensure all tests pass locally before starting the pull request (see below).
3. Ensure all that any change or new feature is reflected in the documentation. Make sure the documentation builds without errors locally (see below).
4. Format all source code consistently with the existing project. This can be automated (see below).
5. Always allow the "editing from maintainers" option in your PR.
6. Feel free to explicitly tag (with `@`) one of the maintainers to request a review of your PR when it is ready.


## Development Environments

The package is developed against two dedicated environments: [`test/`](test/) for running the test suite, and [`docs/`](docs/) for building the documentation. Each has its own `Project.toml` and sources the local package via a `[sources]` entry, so both always use the current checkout. The `test` environment also contains the tooling for coverage analysis (`LocalCoverage`) and code formatting (`JuliaFormatter`). Adding a dependency that is only needed for testing or only for the documentation goes into the respective `Project.toml`, not into the package's own `Project.toml`.

The top-level `Project.toml` declares a [Pkg workspace](https://pkgdocs.julialang.org/v1/workspaces/) containing the `test` and `docs` projects. On Julia >= 1.12, all three environments then resolve into a single manifest at the repository root, guaranteeing consistent package versions between running the tests and building the documentation. On older Julia versions, the workspace is ignored and `test/` and `docs/` keep dedicated manifests. Local development requires Julia >= 1.11 (for `[sources]`).

The recommended workflow uses the [`Makefile`](Makefile); run `make help` to see all targets. On systems without `make`, the underlying commands can be read directly from the `Makefile`.

Use `make clean` to remove coverage and build artifacts, or `make distclean` to restore a clean checkout. Also run `make distclean` when switching between Julia versions, so that no stale manifests are left behind.


## Development REPL

A "development REPL" can be started via

```
make devrepl
```

It is based on the workspace feature and thus requires Julia >= 1.12. This is the recommended way to work interactively. The REPL activates the `test` project and adds the `docs` project to the `LOAD_PATH`, so that the package, the test dependencies, and the documentation dependencies are all available, at the versions pinned in the shared workspace manifest. `Revise` is loaded from your default (global) Julia environment and must be installed there. Inside the REPL:

* `include("test/runtests.jl")` — run the entire test suite in-process (with `Revise` active, this picks up edits to `src/` automatically).
* `include("docs/make.jl")` — build the documentation.

Repeated test runs or documentation builds are much faster this way, since they pay no startup cost.


## Running the Tests

* Run the full test suite in the `test` environment:

  ```
  make test
  ```

* Run it with coverage tracking and print a per-file summary:

  ```
  make coverage
  ```

  Use `make htmlcoverage` to instead write a browsable HTML report to `./coverage`. That requires the `genhtml` executable from the [lcov](https://github.com/linux-test-project/lcov) package.

* Or, start the [development REPL](#development-repl) and run the tests from there.

Without `make`, start a Julia REPL in the test environment with `julia --project=test`, instantiate with `] instantiate`, and then run `include("test/runtests.jl")`.


## Building the Documentation

* Build the HTML documentation into `docs/build`:

  ```
  make docs
  ```

* Or, build it from the [development REPL](#development-repl) with `include("docs/make.jl")`, which is the faster iteration loop.

Without `make`, start a Julia REPL in the docs environment with `julia --project=docs`, instantiate with `] instantiate`, and then run `include("docs/make.jl")`.

To preview the built documentation, you must run a web server, either via the [LiveServer](https://github.com/JuliaDocs/LiveServer.jl) package, or (if you have Python installed), via `python3 -m http.server`. See the [Documenter Guide](https://documenter.juliadocs.org/stable/man/guide/#Note-6b659cc6046c5199) for details.


## Source Code Formatting

This project uses a code style described in `.JuliaFormatter.toml` and enforced via [JuliaFormatter](https://github.com/domluna/JuliaFormatter.jl). For pull requests, adherence to the code style is automatically checked during continuous integration.

To locally apply the code style, run `make codestyle`, or, if you cannot use `make`, run

```
julia --project=test
julia> using JuliaFormatter
julia> format(["src", "docs", "test"])
```

in the project root.


## Maintainer Notes

### PR review and merging

* PRs can be merged by anyone with commit access.
* PRs by authors with commit access can be self-merged after approval from a (co-)maintainer, or directly (without review) for trivial PRs
* The merge pattern outlined in [the README of the `git-merge-pr` script](https://github.com/goerz/git-merge-pr?tab=readme-ov-file#introduction) is encouraged. That is, PRs should be rebased on the current `master`, should preserve any clean history or squash unclean history, and be merged with a merge commit. That merge commit is a good place to also apply editorial changes.


## Release process

Releases are made by the package maintainer only.

- [ ] Create a `release-x.y.z` branch
- [ ] Create a single "release commit":
    - [ ] Check the version number in `Project.toml`, bumping or removing a `-dev` suffix as necessary
- [ ] Push the `release-x.y.z` branch, but do not create a pull request
- [ ] Comment `@JuliaRegistrator register` on the commit that should be tagged as the release
- [ ] Wait for the registration to go through, for TagBot to tag the commit, and for the documentation to be built and deployed
- [ ] Manually merge the `release-x.y.z` branch into `master`, with a merge commit that bumps the version number by applying a `+dev` suffix:
    - [ ] `git merge --no-ff --no-commit release-x.y.z`
    - [ ] Update `Project.toml`
    - [ ] `git commit -m "Bump version to x.y.z+dev"`
- [ ] Push the `master` branch and delete the `release-x.y.z` branch (`git branch -D release-x.y.z && git push origin :release-x.y.z`)
