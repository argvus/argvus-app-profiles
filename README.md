# argvus-app-profiles

Application profiles and ARGVUS launcher wrappers for terminal and TUI tools.

This package owns the app-specific defaults extracted from the legacy `argvus`
repository:

- `bottom`
- `btop`
- `foot`
- `kitty`
- `snappy-switcher`
- `superfile`
- `term`
- `yazi`

It also installs `/usr/bin/argvus`, the compatibility command used by current
ARGVUS bindings and aliases for:

```sh
argvus --btop
argvus --btm
argvus --spf
argvus --yazy
argvus --setup
```

The package intentionally does not depend on the `argvus` metapackage to avoid a
dependency cycle. The full desktop is still installed with:

```sh
pacman -S argvus
```

## Install

```sh
make DESTDIR=/tmp/argvus-app-profiles-dest PREFIX=/usr install
```

## Validate

```sh
make validate
makepkg --printsrcinfo
```
