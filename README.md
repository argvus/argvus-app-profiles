# argvus-app-profiles

Application profiles and ARGVUS launcher wrappers for terminal and TUI tools.
The package owns the profiles of the terminal and TUI tools it ships: superfile and yazi
(configuration, themes and the keymap helper). The Kitty and btop configuration is part of
the `argvus` package and of the terminal and system monitor components.

The `argvus tui-terminal` launcher is part of the `argvus` workspace (`crates/argvus-tui-terminal` in `de/argvus`). It installs the
dedicated `argvus tui-terminal` launcher and the
`argvus app-profiles-yazi-keymap` helper, plus the shared profiles
under `/usr/share/argvus/app-profiles`.

`argvus tui-terminal --profile greeter` creates a Kitty runtime profile for
the login greeter. It inherits the active ARGVUS theme and fonts while hiding
and disabling tab actions for that session only.

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
