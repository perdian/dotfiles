#!/usr/bin/python
import os
import subprocess
import glob
import shutil
import sys
import fnmatch

# Find all the relevant environments that should be activated
activeEnvironments = [ "default" ];
for arg in sys.argv[1:]:
    activeEnvironments.append("manual/" + arg);
if (sys.platform == "darwin"):
    activeEnvironments.append("auto/macos");
elif (sys.platform == "linux" or sys.platform == "linux2"):
    activeEnvironments.append("auto/linux");
print "Resolved active environments: " + str(activeEnvironments);

# Store the list of environments into the .dotfiles-environments file inside the
# users home directory
environmentConfigurationFileContent = "";
for activeEnvironment in activeEnvironments:
    environmentConfigurationFileContent += activeEnvironment + "\n";
environmentConfigurationFileName = os.path.join(os.path.expanduser("~"), ".dotfiles-environments");
environmentConfigurationFile = open(environmentConfigurationFileName, "w");
environmentConfigurationFile.write(environmentConfigurationFileContent);
environmentConfigurationFile.close();

environmentsRootDirectory = os.path.dirname(os.path.abspath(__file__))
print "Bootstrapping dotfiles installation from root directory: " + environmentsRootDirectory

# Resolve all the .symlink files (or directories for that matter) and make sure that they are
# correctly linked into the $HOME directory (or a child directory inside the $HOME directory)
globalErrorHandlingMode = None;
for activeEnvironment in activeEnvironments:
    activeEnvironmentDirectory = os.path.join(environmentsRootDirectory, activeEnvironment);
    if os.path.exists(activeEnvironmentDirectory):

        print "Bootstrapping dotfiles from environment directory: " + activeEnvironmentDirectory;
        for root, dirNames, fileNames in os.walk(activeEnvironmentDirectory):
            for sourceFileName in fnmatch.filter(fileNames + dirNames, '*.symlink'):

                sourceFile = os.path.join(root, sourceFileName)
                sourceFileResolved = os.path.realpath(sourceFile)
                sourceFileName = os.path.basename(sourceFile)

                sourceFileIndexOfSymlink = sourceFileName.find(".symlink");
                sourceFileIndexOfTargetDirectoryName = sourceFileName.find("@");

                if sourceFileIndexOfTargetDirectoryName > -1:
                    targetDirectoryEncoded = sourceFileName[sourceFileIndexOfTargetDirectoryName+1:sourceFileIndexOfSymlink];
                    targetDirectoryName = targetDirectoryEncoded.replace("@", "/");
                    targetDirectory = os.path.join(os.path.expanduser("~"), targetDirectoryName);
                    targetFileName = sourceFileName[0:sourceFileIndexOfTargetDirectoryName];
                else:
                    targetDirectory = os.path.expanduser("~");
                    targetFileName = sourceFileName[0:sourceFileIndexOfSymlink];

                targetFile = os.path.join(targetDirectory, targetFileName);
                targetFileResolved = os.path.realpath(targetFile)

                if os.path.exists(targetFileResolved) and sourceFileResolved == targetFileResolved:

                    # The source file exists and already represents a link to the target
                    # file so there is nothing that we need to do.
                    print "Target '" + str(targetFile) + " already symlinked to '" + str(sourceFileResolved) + "'"

                elif not os.path.exists(targetFileResolved):

                    if os.path.islink(targetFile):
                        os.unlink(targetFile)

                    targetFileParent = os.path.abspath(os.path.join(targetFileResolved, os.pardir));
                    if not os.path.exists(targetFileParent):
                        os.makedirs(targetFileParent);

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

        for root, dirNames, fileNames in os.walk(activeEnvironmentDirectory):
            for bootstrapInstallerFileName in sorted(fnmatch.filter(fileNames, 'bootstrap-installer.*')):
                bootstrapInstallerFile = os.path.join(root, bootstrapInstallerFileName)

                print "Executing installer at: " + str(bootstrapInstallerFile)
                subprocess.call(["chmod", "a+x", str(bootstrapInstallerFile)])
                subprocess.call(str(bootstrapInstallerFile))
