#!/bin/env python3

import sys
import subprocess

LOG_FILE = "/tmp/3fui_ffmpeg.log"
LOG_TAIL_FILE = "/tmp/3fui_ffmpeg.log.tail"
RET_FILE = "/tmp/3fui_ffmpeg.ret"
FINISH_SIGN = "/tmp/3fui_ffmpeg_finish"


def main():
    try:
        ffmpeg_cmd = ['ffmpeg'] + sys.argv[1:]

        with open(LOG_FILE, 'w') as log_file, open(LOG_TAIL_FILE, 'w') as tail_file:
            process = subprocess.Popen(
                ffmpeg_cmd,
                stderr=subprocess.PIPE,
                stdout=subprocess.DEVNULL,
                text=True,
                bufsize=1
            )
            if not process or not process.stderr:
                return

            for line in process.stderr:
                tail_file.seek(0)
                tail_file.write(line)
                tail_file.truncate()
                tail_file.flush()

                log_file.write(line)
                log_file.flush()

            return_code = process.wait()

            with open(RET_FILE, 'w') as ret_file:
                ret_file.write(str(return_code) + '\n')

    except Exception as e:
        with open(RET_FILE, 'w') as ret_file:
            ret_file.write("1\n")

    finally:
        with open(FINISH_SIGN, 'w') as f:
            f.write("")


if __name__ == "__main__":
    main()
