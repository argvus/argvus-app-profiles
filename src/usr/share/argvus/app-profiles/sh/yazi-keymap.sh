#!/usr/bin/env sh

# Materialize the ARGVUS Yazi keymap with translations from argvus-i18n.

set -eu

_source="${1:-${ARGVUS_SYSTEM_CONFIG:-/usr/share/argvus}/app-profiles/config/yazi/keymap.toml}"
_destination="${2:-}"

[ -r "$_source" ] || {
    printf '%s\n' "argvus-app-profiles-yazi-keymap: keymap not found: $_source" >&2
    exit 1
}

# shellcheck disable=SC1091
. /usr/share/argvus/lib/i18n.sh

command -v argvus-i18n >/dev/null 2>&1 || {
    printf '%s\n' 'argvus-app-profiles-yazi-keymap: argvus-i18n is required' >&2
    exit 1
}

translate() {
    argvus_tr app-profiles "$1"
}

toml_escape() {
    sed 's/\\/\\\\/g; s/"/\\"/g'
}

translated() {
    _value="$(translate "$1" | toml_escape)"
    printf 'desc = "%s"\n' "$_value"
}

write_keymap() {
    while IFS= read -r _line || [ -n "$_line" ]; do
        case "$_line" in
            'desc = "Rename"') translated yazi.rename ;;
            'desc = "Open in terminal"') translated yazi.open_terminal ;;
            'desc = "Move to trash"') translated yazi.move_to_trash ;;
            'desc = "Securely destroy (Smog)"') translated yazi.secure_destroy ;;
            'desc = "Empty trash (Smog)"') translated yazi.empty_trash ;;
            'desc = "Open file intelligently"') translated yazi.open_file_smart ;;
            'desc = "Open with VSCode"') translated yazi.open_vscode ;;
            'desc = "Create ZIP archive (zip)"') translated yazi.create_zip ;;
            'desc = "Open with File Roller"') translated yazi.open_file_roller ;;
            *) printf '%s\n' "$_line" ;;
        esac
    done <"$_source"
}

if [ -n "$_destination" ]; then
    mkdir -p "${_destination%/*}"
    write_keymap >"$_destination"
else
    write_keymap
fi
