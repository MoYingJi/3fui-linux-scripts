@echo off
setlocal enabledelayedexpansion

set "log_file=Z:\tmp\3fui_ffmpeg.log"
set "ret_file=Z:\tmp\3fui_ffmpeg.ret"
set "finish_sign=Z:\tmp\3fui_ffmpeg_finish"
set "log_file_tail=Z:\tmp\3fui_ffmpeg.log.tail"

del "%log_file%"
del "%ret_file%"
del "%finish_sign%"
del "%log_file_tail%"

set "delay_script=%1"
shift
set "run-ffmpeg=%1"

set "args="
:loop
shift
if "%~1"=="" goto after_args
set args=!args! "%~1"
goto loop
:after_args
REM

start "" %run-ffmpeg% %args%

:check
if exist "%finish_sign%" (
    set /p ret=<"%ret_file%"
    if not defined ret (
        set ret=1
    )
    type "%log_file%" 1>&2
    exit /b !ret!
) else (
    if exist "%log_file_tail%" (
        type "%log_file_tail%" 1>&2
    )
    cscript %delay_script% 2>nul
    goto check
)

endlocal
