#!/usr/bin/bash
#shellcheck disable=SC2155,SC2164

# 获取当前文件夹

path="$(dirname "$(realpath "$0")")"

# 读取配置

source "$path/config.conf"

[ -z "$VERSION" ] && exit 1
[ -z "$WINE" ] && WINE=wine
[ -z "$WINE_SERVER" ] && WINE_SERVER=wineserver
[ -z "$WINE_PREFIX" ] && WINE_PREFIX="./pfx"
[ -z "$WINE_ARCH" ] && WINE_ARCH="win64"

prog_path="$path/program/$VERSION"

# 准备

chmod +x "$path/scripts/run-ffmpeg.py"

ln -sf "$path/settings/"* "$prog_path/"
ln -sf "$path/scripts" "$prog_path"

export WINEPREFIX="$(cd "$path" && realpath "$WINE_PREFIX")"
export WINEARCH="$WINE_ARCH"

# 运行

cd "$prog_path"

if [ "$SKIP_FAKECHINESE" == "y" ]; then
    $WINE "$prog_path/FFmpegFreeUI.exe"
else
    export FONTCONFIG_FILE="$path/fonts/fonts.conf"
    fc-cache -f "$path/fonts"
    $WINE "$prog_path/FFmpegFreeUI.exe"
fi

[ "$WINE_SERVER_KILL" == "y" ] && $WINE_SERVER -k
