#!/usr/bin/python
import os
import subprocess
import glob
import shutil
import sys
import fnmatch

dotfilesRootDirectory = os.path.dirname(os.path.abspath(__file__))
print "Configure dotfiles from source directory: " + dotfilesRootDirectory

# First we resolve all the .symlink files (or directories for that matter) and
# make sure that they are correctly linked into the $HOME directory
globalErrorHandlingMode = None
for root, dirNames, fileNames in os.walk(dotfilesRootDirectory):
    for sourceFileName in fnmatch.filter(fileNames + dirNames, '*.symlink'):

        sourceFile = os.path.join(root, sourceFileName)
        sourceFileResolved = os.path.realpath(sourceFile)
        sourceFileName = os.path.basename(sourceFile)
        targetFileName = "." + sourceFileName[:-len(".symlink")]
        targetFile = os.path.join(os.path.expanduser("~"), targetFileName)
        targetFileResolved = os.path.realpath(targetFile)

        if os.path.exists(targetFileResolved) and sourceFileResolved == targetFileResolved:
            # The source file exists and already represents a link to the target
            # file so there is nothing that we need to do.
            print "Target '" + str(targetFile) + " already symlinked to '" + str(sourceFileResolved) + "'"
            pass

        elif not os.path.exists(targetFileResolved):
            # File is not existing yet, so we create the symbolic link
            if os.path.islink(targetFile):
                os.unlink(targetFile)
            os.symlink(sourceFile, targetFile)
            print "Symlinked '" + str(targetFile) + "' to '" + str(sourceFileResolved) + "'"

        else:
            # The target file already exists and is not identifical with the file
            # that we would like to place there. So ask the user what to do
            if globalErrorHandlingMode == None:
                print "Target file '" + str(targetFile) + "' is already existing. What do you want to do?"
                print "[s]kip, [S]kip all, [o]verwrite, [O]verwrite all, [b]ackup, [B]ackup all?"
                errorHandlingModeResult = raw_input(">> ")
                if len(errorHandlingModeResult) > 0 and errorHandlingModeResult == errorHandlingModeResult.upper():
                    globalErrorHandlingMode = errorHandlingModeResult.lower()
                errorHandlingMode = errorHandlingModeResult.lower()
            else:
                errorHandlingMode = globalErrorHandlingMode

            if errorHandlingMode == "s" or errorHandlingMode == "":
                pass
            elif errorHandlingMode == "o":
                if os.path.isdir(targetFile):
                    shutil.rmtree(targetFile)
                elif os.path.isfile(targetFile):
                    os.remove(targetFile)
                os.symlink(sourceFile, targetFile)
                print "Symlinked '" + str(targetFile) + "' to '" + str(sourceFileResolved) + "'"
            elif errorHandlingMode == 'b':
                backupFile = targetFile + ".backup"
                print "Moving '" + str(targetFile) + "' to '" + str(backupFile) + "'"
                shutil.move(targetFile, backupFile)
                os.symlink(sourceFile, targetFile)
                print "Symlinked '" + str(targetFile) + "' to '" + str(sourceFileResolved) + "'"

# Now load all the installers
for root, dirNames, fileNames in os.walk(dotfilesRootDirectory):
    for bootstrapInstallerFileName in sorted(fnmatch.filter(fileNames, 'bootstrap-installer.*')):
        bootstrapInstallerFile = os.path.join(root, bootstrapInstallerFileName)

        print "Executing installer at: " + str(bootstrapInstallerFile)
        subprocess.call(["chmod", "a+x", str(bootstrapInstallerFile)])
        subprocess.call(str(bootstrapInstallerFile))
