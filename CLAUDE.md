# CLAUDE.md

Guidance for Claude Code (claude.ai/code) when working in this repository.

## What This Repo Is

A [cookiecutter](https://github.com/cookiecutter/cookiecutter) template that generates Julia packages (requires cookiecutter ≥ 2.4.0 for `pre_prompt` support). The `{{cookiecutter.project_name}}/` directory **is** the template: its files are full of `{{ cookiecutter.variable }}` Jinja2 placeholders and are intentionally *not* valid Julia/TOML/YAML until rendered. Always keep template *source* (this repo) separate from rendered *output* (what a user gets).

Generate a project with `cookiecutter gh:goerz/cookiecutter-juliapackage` (or a local path).

## Layout

- **`cookiecutter.json`** — variables: `project_name` (e.g. `MyPackage.jl`, *includes* the `.jl`), `author`, `email`, `owner` (GitHub user/org), `year`, `version`, `uuid`, `julia_version`. `_copy_without_render: ["*.yml"]` ships all YAML verbatim.
- **`hooks/`**:
  - `pre_prompt.py` — overwrites `uuid` (fresh `uuid4()`) and `year` in `cookiecutter.json` on every run.
  - `pre_gen_project.py` — validates `project_name` against `^[A-Z][a-zA-Z0-9]{4,}\.jl$`.
  - `post_gen_project.sh` (bash) — `git init`, `make codestyle`, `make distclean`, initial commit, GitHub remote.
- **`{{cookiecutter.project_name}}/`** — the generated project: `Makefile` (dev driver, `make help`), `Project.toml`, `test/` & `docs/` environments (each a `[sources]` path dep on the package), `docs/make.jl` (Documenter), `.JuliaFormatter.toml` (92-col, 4-space, alignment), and `.github/workflows/` (`CI.yml` with `test`/`docs`/`codestyle` jobs; `CompatHelper.yml`; `TagBot.yml`; `ClearPreview.yml`).

## Editing the Template

- **Single-quote any path into the template tree** — the `{{ }}` in names triggers bash brace-expansion/globbing. Prefer the Read/Edit/Write tools, which take literal paths.
- **Never run Julia tooling (JuliaFormatter etc.) on the template source** — it corrupts the Jinja. Render first, then run tooling on the output.
- **`uuid`/`year` in `cookiecutter.json` are placeholders** rewritten by `pre_prompt.py`; change the hook, not the stored values.
- **`*.yml` files are copied verbatim**, so their GitHub Actions `${{ }}` survives. You *cannot* put `{{ cookiecutter.* }}` in them; to inject a value, narrow `_copy_without_render` and `{% raw %}`-guard every `${{ }}`, or use a hook.
- **Keep naming rules in sync**: the regex in `pre_gen_project.py`, the `__prompts__` text in `cookiecutter.json`, and any references.

## Verifying Changes

There is no build step. Render into a throwaway dir and inspect — no stray `{{`, `Project.toml` got a real UUID, workflows kept their `${{ }}`:

```bash
cookiecutter --no-input -o /tmp/cc -f . project_name="DemoPkg.jl"
```

To exercise the generated project end-to-end (what `.github/workflows/CI.yml` does, using `MyGithubTestingProject.jl`):

```bash
cd /tmp/cc/DemoPkg.jl && make test && make coverage && make docs
```

Generated-project `Makefile` targets (`make help`): `devrepl`, `test`, `coverage`, `htmlcoverage`, `docs`, `codestyle`, `clean`, `distclean`.

## Generated-Project Conventions

- Default branch is `master` (not `main`).
- The `codestyle` CI job enforces versioning: branch pushes (incl. `master`) must carry a `-dev`/`+dev` suffix; release versions are allowed only on `release-*` branches. Releases are triggered by commenting `@JuliaRegistrator register` on the release commit.
- The `test`/`docs` environments need Julia ≥ 1.11 for the `[sources]` section.

## Package Extensions

If a generated project adds [extension modules](https://docs.julialang.org/en/v1/manual/code-loading/#man-extensions), its `Makefile` needs manual edits: add `"ext"` to the `codestyle` formatter list and `folder_list = ["src", "ext"]` in the `coverage` target.
