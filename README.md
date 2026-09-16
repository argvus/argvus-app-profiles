# argvus-app-profiles

Application profiles and ARGVUS launcher wrappers for terminal and TUI tools.
The package owns the configuration, themes, and shell helpers for bottom, btop,
foot, foot-tui, kitty, kitty-tui, snappy-switcher, superfile, term, and yazi.

It installs the dedicated `/usr/bin/argvus-tui-terminal` launcher and the
`/usr/bin/argvus-app-profiles-yazi-keymap` helper, plus the shared profiles
under `/usr/share/argvus/app-profiles`.

## Build and validate

```sh
make validate
make build
```

The repository follows the standard ARGVUS Arch packaging layout. See
[packaging/arch/README.md](packaging/arch/README.md) for the CI and local
PKGBUILD contract.

## License

GPL-3.0-only. See [LICENSE](LICENSE).
