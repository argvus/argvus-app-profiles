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
	$(INSTALL) -Dm755 bin/argvus \
		"$(DESTDIR)$(PREFIX)/bin/argvus"
	$(INSTALL) -dm755 "$(DESTDIR)$(PREFIX)/share/argvus"
	cp -a config/. "$(DESTDIR)$(PREFIX)/share/argvus/"
	find "$(DESTDIR)$(PREFIX)/share/argvus/scripts" -type f -name '*.sh' -exec chmod 755 {} \; 2>/dev/null || true
	$(INSTALL) -Dm644 LICENSE \
		"$(DESTDIR)$(PREFIX)/share/licenses/argvus-app-profiles/LICENSE"

uninstall:
	$(RM) "$(DESTDIR)$(PREFIX)/bin/argvus"
	for dir in bottom btop foot kitty snappy-switcher superfile term yazi; do \
		rm -rf "$(DESTDIR)$(PREFIX)/share/argvus/$$dir"; \
	done
	$(RM) "$(DESTDIR)$(PREFIX)/share/argvus/scripts/apps/yazi-open-smart.sh"
	$(RM) "$(DESTDIR)$(PREFIX)/share/licenses/argvus-app-profiles/LICENSE"

validate:
	@set -eu; \
	test -x bin/argvus; \
	for dir in bottom btop foot kitty superfile term yazi; do test -d "config/$$dir"; done; \
	scripts=$$(find bin config -type f \( -name '*.sh' -o -path '*/bin/*' \) | sort); \
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
	rm -f packaging/arch/*.zst packaging/arch/*.tar.gz
