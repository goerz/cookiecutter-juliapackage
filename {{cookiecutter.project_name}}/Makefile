.PHONY: help devrepl test coverage htmlcoverage docs clean codestyle distclean
.DEFAULT_GOAL := help

JULIA ?= julia
PORT ?= 8000

define PRINT_HELP_JLSCRIPT
rx = r"^([a-z0-9A-Z_-]+):.*?##[ ]+(.*)$$"
for line in eachline()
    m = match(rx, line)
    if !isnothing(m)
        target, help = m.captures
        println("$$(rpad(target, 20)) $$help")
    end
end
endef
export PRINT_HELP_JLSCRIPT

define DEVREPL_INIT_JLSCRIPT
using Revise
println("""
**Development REPL for {{ cookiecutter.project_name }}** (Revise active)
""")
endef
export DEVREPL_INIT_JLSCRIPT


help:  ## show this help
	@git config --local blame.ignoreRevsFile .git-blame-ignore-revs
	@julia -e "$$PRINT_HELP_JLSCRIPT" < $(MAKEFILE_LIST)

devrepl:  test/Manifest.toml ## Start an interactive REPL for testing and building documentation
	$(JULIA) --project=test -e "$$DEVREPL_INIT_JLSCRIPT" -i

test: ## Run the test suite
	$(JULIA) --project=. -e 'import Pkg; Pkg.test(;coverage=false, julia_args=["--check-bounds=yes", "--compiled-modules=yes", "--depwarn=yes"], force_latest_compatible_version=false, allow_reresolve=true)'

coverage: test/Manifest.toml ## Run the test suite with coverage
	$(JULIA) --project=test -e 'using LocalCoverage; report = generate_coverage("{{ cookiecutter.project_name.replace('.jl', '') }}"; run_test = true); show(report)'

htmlcoverage: test/Manifest.toml ## Run the test suite with coverage and generate an HTML report in ./coverage
	$(JULIA) --project=test -e 'using LocalCoverage; html_coverage("{{ cookiecutter.project_name.replace('.jl', '') }}"; dir = "coverage")'

docs: docs/Manifest.toml ## Build the documentation
	$(JULIA) --project=docs docs/make.jl

clean: ## Clean up build/doc/testing artifacts
	rm -f *.jl.*.cov
	rm -f *.jl.cov
	rm -f *.jl.mem
	rm -rf coverage
	rm -rf docs/build

codestyle: test/Manifest.toml ## Apply the codestyle to the entire project
	$(JULIA) --project=test -e 'using JuliaFormatter; format(["src", "docs", "test"], verbose=true)'

distclean: clean ## Restore to a clean checkout state
	rm -f Manifest.toml
	rm -f test/Manifest.toml
	rm -f docs/Manifest.toml

test/Manifest.toml: test/Project.toml
	@git config --local blame.ignoreRevsFile .git-blame-ignore-revs
	$(JULIA) --project=test -e 'using Pkg; Pkg.instantiate()'

docs/Manifest.toml: docs/Project.toml
	@git config --local blame.ignoreRevsFile .git-blame-ignore-revs
	$(JULIA) --project=docs -e 'using Pkg; Pkg.instantiate()'
