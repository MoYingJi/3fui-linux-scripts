本项目是 3FUI 的一键转译运行方案

自动应用微软雅黑字体 提供了一系列脚本 提供了调用原生 FFmpeg 的默认设置

# 使用方法

将本项目克隆至本地

将程序解压到 `program` 文件夹的任意子文件中 并修改 `config.conf` 的 `VERSION` 为文件夹名称 <br>
如解压到 `./program/FFmpegFreeUI ReadyToRun x64/` 那么 `VERSION` 就是 `FFmpegFreeUI ReadyToRun x64` <br>
也就是主文件在 `./program/FFmpegFreeUI ReadyToRun x64/FFmpegFreeUI.exe` 中 <br>
(本来是为多版本准备的 一般不用改 默认就是 `FFmpegFreeUI ReadyToRun x64`)

在 `config.conf` 中确认配置 <br>
配置中的 wine 必须为原版 wine! 不能是 wine-staging 或 proton!

调用原生 FFmpeg 需要本机有 `/usr/bin/python3` (因为有脚本是 python 写的) <br>
默认配置下 FFmpeg 位于 `/usr/bin/ffmpeg`

允许 `prepare.sh` 以进行准备工作 <br>
此步骤还需要 `winetricks` <br>
目前只有安装 `fakechinese` 下载思源黑体伪装成微软雅黑等字体以解决部分字体问题 <br>
可以手动放入微软雅黑并跳过此步

要运行则执行 `start.sh` 即可

# 其他问题

高分辨率屏幕显示过小 则运行 winecfg.sh 然后在 "显示" 的 "屏幕分辨率" 中调高 DPI 推荐 144

更多问题 参阅 [3FUI Linux 文档](https://github.com/Lake1059/FFmpegFreeUI/blob/main/doc/linux.md)

# 声明

`script` 文件夹下的 `delay.vbs`、`run-ffmpeg.py`、`wait-exit.bat` 均来自 Uyanide
