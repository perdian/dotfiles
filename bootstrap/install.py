#!/usr/bin/python

import fnmatch
import os
import sys
import subprocess
import shutil
import urllib

installRootDirectory = os.path.dirname(os.path.abspath(__file__))

if sys.platform == "darwin":
    # Make sure we have Homebrew installed
    if not subprocess.call("type brew", shell=True, stdout=subprocess.PIPE, stderr=subprocess.PIPE) == 0:
        print "Installing Homebrew for you"
        homebrewInstallScript = urllib.urlopen("https://raw.githubusercontent.com/Homebrew/install/master/install")
        homebrewInstallContent = homebrewInstallScript.read();
        subprocess.call(["ruby", "-e", homebrewInstallContent])
    print "Updating Homebrew"
    subprocess.call(["brew", "update"])
    print "Installing required packages using Homebrew"
    subprocess.call(["brew", "bundle"], cwd = os.path.join(installRootDirectory, "macos/homebrew"))

# To keep the rest of the installation itself modular and easy we delegate the installation steps
# to separate scripts located inside the directory
platformDirectoryName = sys.platform
if sys.platform == "darwin":
    platformDirectoryName = "macos"
elif sys.platform == "linux" or sys.platform == "linux2":
    platformDirectoryName = "linux"

print "Scanning " + platformDirectoryName + " script directory"
for directoryName in ("default", platformDirectoryName):
    for root, dirNames, fileNames in os.walk(os.path.join(installRootDirectory, directoryName)):
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
