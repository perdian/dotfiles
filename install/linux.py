#!/usr/bin/python

import fnmatch
import os
import sys
import subprocess
import shutil
import urllib

installRootDirectory = os.path.dirname(os.path.abspath(__file__))
linuxScriptsDirectory = os.path.join(installRootDirectory, "linux")

# To keep the rest of the installation itself modular and easy we delegate the installation steps
# to separate scripts located inside the "linux" directory
print "Scanning linux script directory"
for root, dirNames, fileNames in os.walk(linuxScriptsDirectory):
    for scriptExtension in ('*.py', '*.sh'):
        for sourceFileName in fnmatch.filter(fileNames + dirNames, scriptExtension):
            scriptFile = os.path.join(root, sourceFileName)
            subprocess.call([str(scriptFile)] + sys.argv[1:])

# Finally make sure to setup the environment
dotfilesRootDirectory = os.path.abspath(os.path.join(installRootDirectory, os.pardir))
environmentsRootDirectory = os.path.abspath(os.path.join(dotfilesRootDirectory, "environments"))
environmentsInstallScript = os.path.abspath(os.path.join(environmentsRootDirectory, "install.py"))
print "Installing dotfiles into home directory"
subprocess.call([str(environmentsInstallScript)] + sys.argv[1:])
