#!/usr/bin/env bash
#shellcheck disable=SC2155,SC2164

# 获取当前文件夹

path="$(dirname "$(realpath "$0")")"

# 读取配置

source "$path/config.conf"

get_prog_path() { echo "$path/program/$1"; }

is_ver_exists() {
    local dir="$(get_prog_path "$1")"
    [ -d "$dir" ] && [ -f "$dir/FFmpegFreeUI.exe" ]
    return $?
}

# 自动检测版本

# 检测解压到子文件夹的情况
if [ -z "$VERSION" ] || [ "$VERSION" = "auto" ]; then
    VERSIONS+=(
        "FFmpegFreeUI ReadyToRun x64"
        "FFmpegFreeUI SelfContained x64"
        "FFmpegFreeUI ReadyToRun x86"
        "FFmpegFreeUI SelfContained x86"
        "FFmpegFreeUI ReadyToRun arm64"
        "FFmpegFreeUI SelfContained arm64"
    )
    for ver in "${VERSIONS[@]}"; do
        if is_ver_exists "$ver"; then
            VERSION="$ver"
            break
        fi
    done
fi
# 检测解压到 `program` 文件夹的情况
if [ -z "$VERSION" ] || [ "$VERSION" = "auto" ]; then
    if is_ver_exists ""; then
        VERSION=""
    else
        if [ "$LANG" = "zh_CN.UTF-8" ]
            then echo "错误: 无法找到程序！确保程序被正确放入！"
            else echo "Error: Can't find program! Make sure program is put in the right place!"
        fi
        exit 1
    fi
fi


# 一些参数
[ -z "$WINE" ] && WINE=wine
[ -z "$WINE_SERVER" ] && WINE_SERVER=wineserver
[ -z "$WINE_PREFIX" ] && WINE_PREFIX="./pfx"
[ -z "$WINE_ARCH" ] && WINE_ARCH="win64"

prog_path="$(realpath "$(get_prog_path "$VERSION")")"

# 准备

mkdir -p "$path/settings"
chmod +x "$path/scripts/run-ffmpeg.py"
# fix: 如果 settings 目录为空，$path/settings/* 会展开为字面量
if [ ! -e "$path/settings/Settings.json" ]; then
    echo "{}" > "$path/settings/Settings.json"
fi
ln -sf "$path/settings/"* "$prog_path/"
ln -sf "$path/scripts" "$prog_path"

export WINEPREFIX="$(cd "$path" && realpath "$WINE_PREFIX")"
export WINEARCH="$WINE_ARCH"

# 运行

cd "$prog_path"

if [ "$SKIP_FAKECHINESE" != "y" ] && [ ! -f "$path/fonts/fonts.conf" ]; then
    if [ "$LANG" = "zh_CN.UTF-8" ]
        then echo "警告: 'fonts.conf' 未找到！请先运行 'prepare.sh' ！ fakechinese 将被跳过！"
        else echo "WARNING: 'fonts.conf' not found! run 'prepare.sh' first! fakechinese will be skipped!"
    fi
    SKIP_FAKECHINESE="y"
fi

if [ "$SKIP_FAKECHINESE" = "y" ]; then
    $WINE "$prog_path/FFmpegFreeUI.exe"
else
    export FONTCONFIG_FILE="$path/fonts/fonts.conf"
    fc-cache -f "$path/fonts"
    $WINE "$prog_path/FFmpegFreeUI.exe"
fi

wait

[ "$WINE_SERVER_KILL" = "y" ] && $WINE_SERVER -k
