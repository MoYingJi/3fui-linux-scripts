# 3FUI Linux Scripts

本项目是 3FUI 的一键 Wine 运行方案

自动应用中文字体，提供了一系列脚本，提供了调用原生 FFmpeg 的默认设置

## 使用方法

将本项目克隆至本地

### 解压

将程序的压缩包放到 `program` 文件夹下解压，程序本体可以位于 `program` 文件夹的子文件夹中，也可以直接位于 `program` 文件夹

(在子文件夹中的特性本来是为多版本准备的，但现在感觉将压缩包放到这个文件夹下并一键解压就能使文件在正确的位置，就留下来了)

### 确认配置

在 `config.conf` 中确认配置 <br/>
配置中的 wine 必须为原版 wine! 不能是 wine-staging 或 proton!

FFmpeg 二进制文件 `ffmpeg` 需要位于 `$PATH` 下 <br/>
同时 `$PATH` 下还需要有 `python3` (因为有脚本是 Python 写的)

### 准备工作

运行 `prepare.sh` 以进行准备工作

此步骤会配置中文字体 (默认为 `SourceHanSerif.ttc`) 解决中文乱码问题。也可将自己的字体放入 `fonts` 文件夹下并修改配置中的 `FONT_FILE` 和 `FONT_NAME`

也可以手动在 `$WINEPREFIX/drive_c/windows/Fonts/` 中放入微软雅黑并跳过此步，在配置文件中将 `SKIP_FAKECHINESE` 设置为 `y` 即可跳过

### 运行

要运行则执行 `start.sh` 即可

## 其他问题

高分辨率屏幕显示过小，可以运行 `winecfg.sh` 然后在「显示」的「屏幕分辨率」中调高 DPI，推荐 144

更多问题 参阅 [3FUI Linux 文档](https://github.com/Lake1059/FFmpegFreeUI/blob/main/doc/linux.md)

## 声明

`script` 文件夹下的 `delay.vbs`、`run-ffmpeg.py`、`wait-exit.bat` 均来自 [Uyanide](https://github.com/Uyanide)
