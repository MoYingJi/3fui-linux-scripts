#!/usr/bin/env bash
#shellcheck disable=SC2155

set -euo pipefail

# 获取当前文件夹

path="$(dirname "$(realpath "$0")")"

# 读取配置

source "$path/config.conf"

WINE_PREFIX="${WINE_PREFIX:-./pfx}"
WINE_ARCH="${WINE_ARCH:-win64}"

export WINEPREFIX="$(cd "$path" && realpath "$WINE_PREFIX")"
export WINEARCH="$WINE_ARCH"

mkdir -p "$path/settings"
cp -f "$path/resources/Settings.json" "$path/settings/Settings.json"

# 安装中文字体

if [ "$SKIP_FAKECHINESE" != "y" ]; then
    FONT_FILE="${FONT_FILE:-SourceHanSerif.ttc}"
    FONT_NAME="${FONT_NAME:-Source Han Serif}"

    # 安装临时字体 (解决 RichTextEdit 控件乱码，同时作为 UI 字体)

    cat > "$path/fonts/fonts.conf" <<EOF
<?xml version="1.0"?>
<!DOCTYPE fontconfig SYSTEM "fonts.dtd">
<fontconfig>
    <dir>$path/fonts</dir>
</fontconfig>
EOF

    sed -i 's/\("字体":\s*\)"\([^"]*\)"/\1"'"$FONT_NAME"'"/' "$path/settings/Settings.json"

    # 伪装指定字体为 Tahoma (解决弹窗乱码)

    TEMP_REG_FILE="$(mktemp --suffix=.reg)"
    cat > "$TEMP_REG_FILE" <<EOF
REGEDIT4

[HKEY_LOCAL_MACHINE\\Software\\Microsoft\\Windows NT\\CurrentVersion\\FontLink\\SystemLink]
"Tahoma"="fake-tahoma.ttc"
EOF

    wine regedit "$TEMP_REG_FILE"
    rm -f "$TEMP_REG_FILE"

    ln -sf "$path/fonts/$FONT_FILE" "$WINEPREFIX/drive_c/windows/Fonts/fake-tahoma.ttc"
fi

echo "已完成准备工作。可随时运行 $path/start.sh 启动程序。"
