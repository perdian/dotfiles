#!/usr/bin/python
import glob
import os
import subprocess
import sys

files = sys.argv[1:] if len(sys.argv) > 1 else glob.glob('*')
for file in files:
    if os.path.isfile(file):

        fileWithoutExtension = os.path.splitext(file)[0]
        fileWithM4rExtension = fileWithoutExtension + ".m4r";
        print "Converting " + file + "..."

        subprocess.call([
            "ffmpeg",
            "-i", str(file),
            "-ac", "1",
            "-acodec", "aac",
            "-f", "mp4",
            "-b:a", "96k",
            "-t", "40",
            "-y",
            fileWithM4rExtension
        ])
