#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"
ROOT_DIR="$(cd -- "$SCRIPT_DIR/../.." && pwd)"
die() { printf 'error: %s\n' "$1" >&2; exit 1; }
require_command() { command -v "$1" >/dev/null 2>&1 || die "required command not found: $1"; }
require_command bash
require_command makepkg
require_command shellcheck
cd "$ROOT_DIR"
mapfile -t shell_files < <(find src tools packaging/arch/common -type f -name '*.sh' -print | sort)
shellcheck "${shell_files[@]}"
bash -n "${shell_files[@]}"
metadata() {
  bash -c 'source "$1"; printf "%s\n" "$pkgname" "$pkgver" "$pkgrel" "$pkgdesc"; printf "%s\n" "${arch[*]}" "${license[*]}" "${depends[*]}"; printf "%s\n" "${makedepends[*]}" "${options[*]}"' bash "$1"
}
remote_metadata="$(metadata packaging/arch/remote/PKGBUILD)"
local_metadata="$(metadata packaging/arch/local/PKGBUILD)"
[[ "$remote_metadata" == "$local_metadata" ]] || die "remote and local PKGBUILD metadata is out of sync"
for pkgbuild_dir in packaging/arch/remote packaging/arch/local; do
  ( cd "$pkgbuild_dir"; makepkg -p PKGBUILD --printsrcinfo >/dev/null )
done
# Yazi flavors shipped by this repository: a flavor.toml that is not TOML, or a
# tmtheme.xml that is not a plist, breaks theme switching, so fail here.
flavors_dir="src/usr/share/argvus/app-profiles/config/yazi/flavors"
if [[ -d "$flavors_dir" ]]; then
  python3 -I -c '
import pathlib, plistlib, sys, tomllib
failed = False
for flavor in sorted(pathlib.Path(sys.argv[1]).glob("*.yazi")):
  try:
    tomllib.loads((flavor / "flavor.toml").read_text(encoding="utf-8"))
  except (OSError, tomllib.TOMLDecodeError) as error:
    print(f"invalid flavor.toml: {flavor}: {error}", file=sys.stderr)
    failed = True
  tmtheme = flavor / "tmtheme.xml"
  if tmtheme.exists():
    try:
      plistlib.loads(tmtheme.read_bytes())
    except Exception as error:
      print(f"invalid tmtheme.xml: {tmtheme}: {error}", file=sys.stderr)
      failed = True
sys.exit(1 if failed else 0)
' "$flavors_dir" || die "invalid Yazi flavor files"
fi
git diff --check
printf 'Validation OK\n'
