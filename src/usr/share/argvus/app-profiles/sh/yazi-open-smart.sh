#!/usr/bin/env sh

# shellcheck disable=SC1090,SC1091
ARGVUS_BOOTSTRAP="${ARGVUS_BOOTSTRAP:-${ARGVUS_SYSTEM_CONFIG:-/usr/share/argvus}/session/sh/bootstrap.sh}"
. "$ARGVUS_BOOTSTRAP"

# Default apps resolve from the argvus-control-center Apps state (via variables.sh),
# falling back to the Argvus built-ins.
EDITOR="${TERMINAL_EDITOR:-vim}"
TEXT_EDITOR="${TEXT_EDITOR:-mousepad}"
YAZI="$FILE_MANAGER"
[ -n "$YAZI" ] || YAZI="/usr/bin/yazi"
case "$YAZI" in
    spf|superfile) YAZI="argvus --spf" ;;
    yazi) YAZI="argvus --yazy" ;;
esac
ZATHURA="${PDF_VIEWER:-zathura}"
IMAGE_VIEWER="${IMAGE_VIEWER:-imv}"
VIDEO_PLAYER="${VIDEO_PLAYER:-mpv}"
AUDIO_PLAYER="${AUDIO_PLAYER:-audacious}"
ARCHIVE_APP="${ARCHIVE_APP:-xarchiver}"

target=$1

[ -z "$target" ] && exit 1

if [ -d "$target" ]; then
    # Generate the localized keymap once for this Yazi process. The main Yazi
    # profile remains the canonical en-US configuration when used directly.
    _yazi_keymap="$(mktemp "${TMPDIR:-/tmp}/argvus-yazi-keymap.XXXXXX")"
    trap 'rm -f "$_yazi_keymap"' EXIT HUP INT TERM
    argvus-app-profiles-yazi-keymap \
        "$(paths_config "app-profiles/config/yazi/keymap.toml")" \
        "$_yazi_keymap"

    _yazi_config="$(mktemp -d "${TMPDIR:-/tmp}/argvus-yazi-config.XXXXXX")"
    trap 'rm -f "$_yazi_keymap"; rm -rf "$_yazi_config"' EXIT HUP INT TERM
    cp -R --no-preserve=ownership \
        "$(paths_config "app-profiles/config/yazi")/." "$_yazi_config/"
    cp "$_yazi_keymap" "$_yazi_config/keymap.toml"

    case "$YAZI" in
        "argvus --spf")
            YAZI_CONFIG_HOME="$_yazi_config" argvus-tui-terminal \
                --class argvus-file-manager --term foot -- \
                argvus --spf "$target" >/dev/null 2>&1 &
            ;;
        "argvus --yazy"|"argvus --yazi")
            YAZI_CONFIG_HOME="$_yazi_config" argvus-tui-terminal \
                --class argvus-file-manager --term foot -- \
                argvus --yazy "$target" >/dev/null 2>&1 &
            ;;
        *)
            # Keep arbitrary configured terminal file managers working while
            # the ARGVUS Superfile/Yazi wrappers use the dedicated Foot path.
            # shellcheck disable=SC2086
            YAZI_CONFIG_HOME="$_yazi_config" foot -e $YAZI "$target" \
                >/dev/null 2>&1 &
            ;;
    esac
    exit 0
fi

mime=$(file -Lb --mime-type "$target")

case "$mime" in
    text/*|application/json|\
    inode/x-empty|\
    application/xml|\
    application/toml|\
    application/x-yaml|\
    application/x-shellscript)
        "$TEXT_EDITOR" "$target" >/dev/null 2>&1 &
        ;;
    application/pdf|application/x-pdf|application/x-bzpdf|application/x-gzpdf|image/vnd.pdf|image/vnd.djvu|image/vnd.djvu+multipage)
        "$ZATHURA" "$target" >/dev/null 2>&1 &
        ;;
    image/*)
        "$IMAGE_VIEWER" "$target" >/dev/null 2>&1 &
        ;;
    video/*)
        "$VIDEO_PLAYER" "$target" >/dev/null 2>&1 &
        ;;
    audio/*)
        "$AUDIO_PLAYER" "$target" >/dev/null 2>&1 &
        ;;
    application/zip|\
    application/x-7z-compressed|\
    application/x-rar|\
    application/x-tar|\
    application/gzip|\
    application/x-bzip2|\
    application/x-xz)
        "$ARCHIVE_APP" "$target" >/dev/null 2>&1 &
        ;;
    *)
        xdg-open "$target" >/dev/null 2>&1 &
        ;;
esac
exit 0
