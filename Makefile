.DEFAULT_GOAL := help

# Determine this makefile's path.
# Be sure to place this BEFORE `include` directives, if any.
THIS_FILE := $(lastword $(MAKEFILE_LIST))
VERSION := 0.0.0
COMMIT := $(shell git describe --always --long --dirty)

help: ## Show this help.
	@fgrep -h "##" $(MAKEFILE_LIST) | fgrep -v fgrep | sed -e 's/\\$$//' | sed -e 's/##//'

clean-venv: ## re-create virtual env
	rm -rf .venv
	python3 -m venv .venv
	( \
       . .venv/bin/activate; \
       pip install --upgrade pip setuptools; \
    )

clean-ansible: ## delete the $HOME/.ansible directory including galaxy-installed roles
	@rm -rf $${HOME}/.ansible


roles:  clean-venv ## install ansible roles from galaxy
	( \
       . .venv/bin/activate; \
       ansible-galaxy install -r ansible_requirements.yml; \
       ansible-galaxy install git+https://github.com/natemarks/ansible-role-shell.git,$(VERSION); \
    )

molecule-test: ## Run molecule
	( \
	   . .venv/bin/activate; \
	   pip install ansible yamllint ansible-lint molecule[docker]; \
	   molecule test; \
    )

shellcheck: ## execute shellcheck
	   shellcheck templates/*.sh
	   shellcheck templates/*.local

bump: ## bump version in main branch
ifeq ($(CURRENT_BRANCH), $(MAIN_BRANCH))
	( \
	   . .venv/bin/activate; \
	   pip install bump2version; \
	   bump2version $(part); \
	)
else
	@echo "UNABLE TO BUMP - not on Main branch"
	$(info Current Branch: $(CURRENT_BRANCH), main: $(MAIN_BRANCH))
endif

static: shellcheck molecule-test
.PHONY: run build release static upload vet lint
