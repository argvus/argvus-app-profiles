# argvus-app-profiles

<div align="center">

[![CI](https://github.com/argvus/argvus-app-profiles/actions/workflows/ci.yml/badge.svg?branch=main)](https://github.com/argvus/argvus-app-profiles/actions/workflows/ci.yml)
[![License](https://img.shields.io/github/license/argvus/argvus-app-profiles)](./LICENSE)
[![Language: Shell](https://img.shields.io/badge/Shell-POSIX-4EAA25?logo=gnubash&logoColor=white)](https://www.gnu.org/software/bash/)
[![Platform: Arch Linux | Wayland](https://img.shields.io/badge/platform-Arch%20Linux%20%7C%20Wayland-1793D1?logo=archlinux&logoColor=white)](https://archlinux.org/)
[![Pull requests](https://img.shields.io/github/issues-pr/argvus/argvus-app-profiles)](https://github.com/argvus/argvus-app-profiles/pulls)
[![Issues](https://img.shields.io/github/issues/argvus/argvus-app-profiles)](https://github.com/argvus/argvus-app-profiles/issues)
[![Last commit](https://img.shields.io/github/last-commit/argvus/argvus-app-profiles)](https://github.com/argvus/argvus-app-profiles/commits/main)

</div>

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
[packaging/arch/README.md](packaging/arch/README.md) for the remote and local
PKGBUILD contract.

## Contributing and policies

- [CONTRIBUTING.md](https://github.com/argvus/.github/blob/main/CONTRIBUTING.md) — contribution workflow
- [SECURITY.md](https://github.com/argvus/.github/blob/main/SECURITY.md) — private vulnerability reports
- [Code of Conduct](https://github.com/argvus/.github/blob/main/policies/CODE_OF_CONDUCT.md) — community standards
- [AI usage policy](https://github.com/argvus/.github/blob/main/policies/IA_USAGE.md) — rules for AI-assisted contributions

## License

GPL-3.0-only. See [LICENSE](LICENSE).
