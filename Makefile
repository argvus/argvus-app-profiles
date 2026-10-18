.PHONY: help build package install clean validate lint-shell check changelog
.DEFAULT_GOAL := help

help:
	@echo "Available targets:"
	@echo "  make build           - validate and create the local Arch package"
	@echo "  make package         - create the package in build/dist/"
	@echo "  make install         - install the locally built package (sudo pacman -U)"
	@echo "  make clean           - remove build/"
	@echo "  make validate        - validate scripts, shared files and PKGBUILD metadata"
	@echo "  make check           - run the shell lint"
	@echo "  make lint-shell      - shellcheck and bash -n for the shell scripts"
	@echo "  make changelog       - regenerate CHANGELOG.md with git-cliff"

lint-shell:
	@for root in tools packaging/arch/common src; do \
		if [ -d "$$root" ]; then \
			find "$$root" -type f -name '*.sh' -exec shellcheck -e SC1090 -e SC2034 -e SC2154 {} +; \
		fi; \
	done
	@for root in tools packaging/arch/common src; do \
		if [ -d "$$root" ]; then \
			find "$$root" -type f -name '*.sh' -exec bash -n {} +; \
		fi; \
	done
	@git diff --check
	@echo "Lint Shell OK"

check: lint-shell

package: lint-shell
	@tools/sh/pkgbuild_local.sh

build: package

install: package
	@sudo pacman -U build/dist/*.zst --overwrite="*" --noconfirm

validate:
	@sh tools/sh/sync-skeleton.sh --check
	@shellcheck tools/sh/pkgbuild_local.sh
	@cd packaging/arch/ci && makepkg -p PKGBUILD --printsrcinfo >/dev/null
	@cd packaging/arch/local && makepkg -p PKGBUILD --printsrcinfo >/dev/null
	@echo "Validation OK"

changelog:
	@git-cliff -o CHANGELOG.md

clean:
	@rm -rf build/
