#!/usr/bin/bash
#shellcheck disable=SC2155,SC2164

# 获取当前文件夹

path="$(dirname "$(realpath "$0")")"

# 读取配置

source "$path/config.conf"

[ -z "$WINE_TRICKS" ] && WINE_TRICKS=winetricks
[ -z "$WINE_PREFIX" ] && WINE_PREFIX="./pfx"
[ -z "$WINE_ARCH" ] && WINE_ARCH="win64"

export WINEPREFIX="$(cd "$path" && realpath "$WINE_PREFIX")"
export WINEARCH="$WINE_ARCH"

# 安装中文字体

[ "$SKIP_FAKECHINESE" == "y" ] || $WINE_TRICKS fakechinese
