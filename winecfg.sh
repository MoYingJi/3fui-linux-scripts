#!/usr/bin/bash
#shellcheck disable=SC2155

path="$(dirname "$(realpath "$0")")"

source "$path/config.conf"

[ -z "$WINE_CFG" ] && WINE_CFG=winecfg
[ -z "$WINE_PREFIX" ] && WINE_PREFIX="./pfx"
[ -z "$WINE_ARCH" ] && WINE_ARCH="win64"

export WINEPREFIX="$(cd "$path" && realpath "$WINE_PREFIX")"
export WINEARCH="$WINE_ARCH"

$WINE_CFG
