# No (file) targets are assumed for most Makefile commands.
.PHONY:
	init_day

help: ## Print help.
	@echo Possible commands:
	@cat Makefile | grep '##' | grep -v "Makefile" | sed -e 's/^/  - /'

install_dev: ## Install developer dependencies.
	pip install --upgrade pip
	pip install -r requirements-dev.txt
	pre-commit install
