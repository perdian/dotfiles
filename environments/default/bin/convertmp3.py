#!/usr/bin/python
import glob
import os
import subprocess
import sys

files = sys.argv[1:] if len(sys.argv) > 1 else glob.glob('*')
for file in files:
    if os.path.isfile(file):

        fileWithoutExtension = os.path.splitext(file)[0]
        fileWithMp3Extension = fileWithoutExtension + ".mp3";
        print "Converting " + file + "..."

        subprocess.call([
            "ffmpeg",
            "-i", str(file),
            "-ab", "128k",
            fileWithoutExtension + ".mp3"
        ])
