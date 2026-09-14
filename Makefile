PREFIX ?= /usr
DESTDIR ?=
INSTALL ?= install
RM ?= rm -f

.DEFAULT_GOAL := help

.PHONY: help install uninstall validate build clean

help:
	@echo "Available targets:"
	@echo "  make build"
	@echo "  make install"
	@echo "  make uninstall"
	@echo "  make validate"

install:
	$(INSTALL) -Dm755 bin/argvus-tui-terminal \
		"$(DESTDIR)$(PREFIX)/bin/argvus-tui-terminal"
	$(INSTALL) -dm755 "$(DESTDIR)$(PREFIX)/share/argvus/app-profiles"
	cp -R --no-preserve=ownership src/usr/share/argvus/app-profiles/. "$(DESTDIR)$(PREFIX)/share/argvus/app-profiles/"
	find "$(DESTDIR)$(PREFIX)/share/argvus/app-profiles/sh" -type f -name '*.sh' -exec chmod 755 {} \; 2>/dev/null || true
	$(INSTALL) -Dm644 LICENSE \
		"$(DESTDIR)$(PREFIX)/share/licenses/argvus-app-profiles/LICENSE"

uninstall:
	$(RM) "$(DESTDIR)$(PREFIX)/bin/argvus-tui-terminal"
	rm -rf "$(DESTDIR)$(PREFIX)/share/argvus/app-profiles"
	$(RM) "$(DESTDIR)$(PREFIX)/share/licenses/argvus-app-profiles/LICENSE"

validate:
	@set -eu; \
	test -x bin/argvus-tui-terminal; \
	test -d src/usr/share/argvus/app-profiles/config; \
	test -d src/usr/share/argvus/app-profiles/sh; \
	scripts=$$(find bin src -type f \( -name '*.sh' -o -path '*/bin/*' \) | sort); \
	for script in $$scripts; do sh -n "$$script"; done; \
	if command -v shellcheck >/dev/null 2>&1; then \
		for script in $$scripts; do shellcheck -e SC1090 -e SC1091 -e SC2034 "$$script"; done; \
	else \
		echo "shellcheck not found; skipped"; \
	fi
	@echo "argvus-app-profiles validation ok"

build:
	@tools/build-local-package.sh

clean:
	rm -rf dist
	rm -f packaging/arch/*.zst packaging/arch/*.tar.gz
