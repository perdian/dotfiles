#!/usr/bin/python
import glob
import os
import subprocess
import sys

files = sys.argv[1:] if len(sys.argv) > 1 else glob.glob('*')
for file in files:
    if os.path.isfile(file):

        fileWithoutExtension = os.path.splitext(file)[0]
        fileWithAacExtension = fileWithoutExtension + ".aac";
        fileWithM4rExtension = fileWithoutExtension + ".m4r";
        print "Converting " + file + "..."

        subprocess.call([
            "ffmpeg",
            "-i", str(file),
            "-ac", "1",
            "-ab", "128000",
            "-f", "mp4",
            "-y",
            fileWithAacExtension
        ])
        subprocess.call([
            "mv", fileWithAacExtension, fileWithM4rExtension
        ])

