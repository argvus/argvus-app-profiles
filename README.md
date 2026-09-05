# argvus-app-profiles

Application profiles and ARGVUS launcher wrappers for terminal and TUI tools.

This package owns the app-specific defaults extracted from the legacy `argvus`
repository:

- `bottom`
- `btop`
- `foot`
- `foot-tui`
- `kitty`
- `kitty-tui`
- `snappy-switcher`
- `superfile`
- `term`
- `yazi`

It also installs `/usr/bin/argvus`, the compatibility command used by current
ARGVUS bindings and aliases, and `/usr/bin/argvus-tui-terminal`, the dedicated
terminal launcher for desktop-opened TUI windows. Terminal and TUI launchers use
the Terminal font selected in `argvus-settings`. File-manager TUIs such as
`superfile` and `yazi` use the Applications font when launched by ARGVUS, while
the app profiles remain owned by this package.

```sh
argvus --btop
argvus --btm
argvus --spf
argvus --yazy
argvus --setup
argvus --about
argvus --calendar
argvus --default-apps    # opens argvus-settings --page apps
argvus --settings
argvus --storage
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
