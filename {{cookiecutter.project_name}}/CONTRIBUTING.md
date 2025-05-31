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


## Source Code Formatting

This project uses a code style described in `.JuliaFormatter.toml` and enforced via [JuliaFormatter](https://github.com/domluna/JuliaFormatter.jl). For pull requests, adherence to the code style is automatically checked during continuous integration.

To apply the code style locally, you should have `JuliaFormatter` installed in your global Julia environment. Then, in a Julia REPL within the project folder, run `using JuliaFormatter; format(".")`.

Alternatively, if you are on Unix and have `make` installed, run `make codestyle`. See `make help` for details.


## Running the Tests

There are a few way to run the tests:

* Start a Julia REPL with `julia --project=.`, then type `] test`.

* If you are on Unix and have `make` installed, run `make test`. Also consider `make devrepl`, `make coverage` and `make htmlcoverage`, see `make help` for details.

* Start a Julia REPL in the test environment with `julia --project=test`. Instantiate with `] instantiate`, then run the tests with `include("test/runtests.jl")`. On Julia < 1.11, you may need `] dev .` to ensure that the test environment uses the current code.

Run `make clean` or `make distclean` to delete coverage information, see `make help` for details.


## Building the Documentation

Use one of the following two possibilities to build the documentation locally:

* Start a Julia REPL in the docs environment with `julia --project=docs`. Instantiate with `] instantiate`, then build the documentation with `include("docs/make.jl")`. On Julia < 1.11, you may need `] dev .` to ensure that the test environment uses the current code. You can also use `make devrepl`

* If you are on Unix and have `make` installed, run `make docs`. See `make help` for details.

This will build the documentation in `./docs/build`. The preview it, you must run a web server, either via the [LiveServer](https://github.com/JuliaDocs/LiveServer.jl) package, or (if you have Python installed), via `python3 -m http.server`. See the [Documenter Guide](https://documenter.juliadocs.org/stable/man/guide/#Note-6b659cc6046c5199) for details.

Run `make clean` or `make distclean` to remove the documentation build, see `make help` for details.


## Maintainer Notes

### PR review and merging

* PRs can be merged by anyone with commit access.
* PRs by authors with commit access can be self-merged after approval from a (co-)maintainer, or directly (without review) for trivial PRs
* The merge pattern outlined in [the README of the `git-merge-pr` script](https://github.com/goerz/git-merge-pr?tab=readme-ov-file#introduction) is encouraged. That is, PRs should be rebased on the current `master`, should preserve any clean history or squash unclean history, and be merged with a merge commit. That merge commit is a good place to also apply editorial changes, such as updating the version number of the changelog.


## Release process

Releases are made by the package maintainer only.

- [ ] Create a `release-x.y.z` branch
- [ ] Create a single "release commit":
    - [ ] Check the version number in `Project.toml`, bumping or removing a `-dev` suffix as necessary
    - [ ] Ensure the `CHANGELOG.md` is complete and up-to-date
- [ ] Push the `release-x.y.z` branch, but do not create a pull request
- [ ] Comment `@JuliaRegistrator register` on the commit that should be tagged as the release
- [ ] Wait for the registration to go through, for TagBot to tag the commit, and for the documentation to be built and deployed
- [ ] Manually merge the `release-x.y.z` branch into `master`, with a merge commit that bumps the version number by applying a `+dev` suffix:
    - [ ] `git merge --no-ff --no-commit release-x.y.z`
    - [ ] Update `Project.toml`
    - [ ] `git commit -m "Bump version to x.y.z+dev"`
- [ ] Push the `master` branch and delete the `release-x.y.z` branch (`git branch -D release-x.y.z && git push origin :release-x.y.z`)
