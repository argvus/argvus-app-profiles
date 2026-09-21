#!/usr/bin/env bash
# shellcheck shell=bash
# shellcheck disable=SC2154
# srcdir, pkgdir, pkgname, and pkgver are supplied by makepkg.

arch_normalize_source_tree() {
  local expected="${srcdir}/${pkgname}-${pkgver}"
  local -a roots=()
  while IFS= read -r -d '' root; do roots+=("$root"); done < <(find "$srcdir" -mindepth 1 -maxdepth 1 -type d -print0)
  if (( ${#roots[@]} != 1 )); then
    printf 'error: expected exactly one extracted source directory in %s\n' "$srcdir" >&2
    return 1
  fi
  if [[ "${roots[0]}" != "$expected" ]]; then
    [[ ! -e "$expected" ]] || { printf 'error: source destination already exists: %s\n' "$expected" >&2; return 1; }
    mv -- "${roots[0]}" "$expected"
  fi
}

arch_check_app_profiles_payload() {
  local source_root="${srcdir}/${pkgname}-${pkgver}" script
  test -x "${source_root}/src/usr/bin/argvus-tui-terminal"
  test -d "${source_root}/src/usr/share/argvus/app-profiles/config"
  test -d "${source_root}/src/usr/share/argvus/app-profiles/sh"
  while IFS= read -r -d '' script; do sh -n "$script"; done < <(find "${source_root}/src" -type f -name '*.sh' -print0)
}

arch_package_app_profiles_payload() {
  local source_root="${srcdir}/${pkgname}-${pkgver}"
  install -Dm755 "${source_root}/src/usr/bin/argvus-tui-terminal" "${pkgdir}/usr/bin/argvus-tui-terminal"
  install -Dm755 "${source_root}/src/usr/share/argvus/app-profiles/sh/yazi-keymap.sh" "${pkgdir}/usr/bin/argvus-app-profiles-yazi-keymap"
  install -dm755 "${pkgdir}/usr/share/argvus/app-profiles"
  cp -R --no-preserve=ownership "${source_root}/src/usr/share/argvus/app-profiles/." "${pkgdir}/usr/share/argvus/app-profiles/"
  # snappy-switcher does not consume the ARGVUS app-profiles tree directly.
  # Its native loader searches flat <name>.ini files in this system directory.
  install -dm755 "${pkgdir}/usr/share/snappy-switcher/themes"
  while IFS= read -r -d '' theme; do
    install -Dm644 "$theme" \
      "${pkgdir}/usr/share/snappy-switcher/themes/$(basename "$(dirname "$theme")").ini"
  done < <(find "${source_root}/src/usr/share/argvus/app-profiles/config/snappy-switcher/themes" \
    -mindepth 2 -maxdepth 2 -type f -name theme.ini -print0)
  find "${pkgdir}/usr/share/argvus/app-profiles/sh" -type f -name '*.sh' -exec chmod 755 {} +
  install -Dm644 "${source_root}/LICENSE" "${pkgdir}/usr/share/licenses/${pkgname}/LICENSE"
}
