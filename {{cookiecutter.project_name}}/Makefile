.PHONY: help devrepl test docs clean codestyle distclean
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


help:  ## show this help
	@git config --local blame.ignoreRevsFile .git-blame-ignore-revs
	@julia -e "$$PRINT_HELP_JLSCRIPT" < $(MAKEFILE_LIST)

devrepl:  test/Manifest.toml ## Start an interactive REPL for testing and building documentation
	$(JULIA) --project=test --banner=no --startup-file=yes

test: test/Manifest.toml ## Run the test suite
	$(JULIA) --project=test --code-coverage=.coverage/tracefile-%p.info --banner=no --startup-file=yes -e 'include("test/runtests.jl")'

docs: docs/Manifest.toml ## Build the documentation
	$(JULIA) --project=docs docs/make.jl

clean: ## Clean up build/doc/testing artifacts
	rm -f *.jl.*.cov
	rm -f *.jl.cov
	rm -f *.jl.mem
	rm -rf /docs/build

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
