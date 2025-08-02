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

cp -f "$path/settings/Settings.json.bak" "$path/settings/Settings.json"

# 安装中文字体

[ "$SKIP_FAKECHINESE" == "y" ] || (
    [ -z "$FONT_PATH" ] && FONT_PATH="$path/fonts/SourceHanSerif.ttc"
    [ -z "$FONT_NAME" ] && FONT_NAME="Source Han Serif"

    # 安装临时字体 (解决 RichTextEdit 控件乱码，同时作为 UI 字体)

    cp -f "$FONT_PATH" "$path/fonts/"

    cat > "$path/fonts/fonts.conf" <<EOF
<?xml version="1.0"?>
<!DOCTYPE fontconfig SYSTEM "fonts.dtd">
<fontconfig>
    <dir>$path/fonts</dir>
</fontconfig>
EOF

    sed -i 's/\("\\u5B57\\u4F53":\s*\)"\([^"]*\)"/\1"'"$FONT_NAME"'"/' "$path/settings/Settings.json"

    # 伪装指定字体为 Tahoma (解决弹窗乱码)

    TEMP_REG_FILE="$(mktemp --suffix=.reg)"
    cat > "$TEMP_REG_FILE" <<EOF
REGEDIT4

[HKEY_LOCAL_MACHINE\\Software\\Microsoft\\Windows NT\\CurrentVersion\\FontLink\\SystemLink]
"Tahoma"="fake-tahoma.ttc"
EOF

    wine regedit "$TEMP_REG_FILE"
    rm -f "$TEMP_REG_FILE"

    ln -sf "$FONT_PATH" "$WINEPREFIX/drive_c/windows/Fonts/fake-tahoma.ttc"
)
