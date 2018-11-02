#!/usr/bin/python
import os
import subprocess
import glob
import shutil
import sys
import fnmatch

activeEnvironments = [ "default" ];
manualEnvironments = [];
if (sys.platform == "darwin"):
    activeEnvironments.append("macos");
elif (sys.platform == "linux" or sys.platform == "linux2"):
    activeEnvironments.append("linux");
for arg in sys.argv[1:]:
    activeEnvironments.append(arg);
    manualEnvironments.append(arg);
print "Resolved active environments: " + str(activeEnvironments);
print "Resolved manual environments: " + str(manualEnvironments);

# If we're on macOS we want to make sure that both Homebrew and zsh are installed as these are the
# two major preconditions that the dotfiles are having
if (sys.platform == "darwin"):
    if not subprocess.call("type brew", shell=True, stdout=subprocess.PIPE, stderr=subprocess.PIPE) == 0:
        print "Installing Homebrew for you"
        homebrewInstallScript = urllib.urlopen("https://raw.githubusercontent.com/Homebrew/install/master/install")
        homebrewInstallContent = homebrewInstallScript.read();
        subprocess.call(["ruby", "-e", homebrewInstallContent])
    if not subprocess.call("type zsh", shell=True, stdout=subprocess.PIPE, stderr=subprocess.PIPE) == 0:
        print "Installing zsh for you"
        subprocess.call(["brew", "install", "zsh"])

# Store the list of environments into the .dotfiles-environments file inside the
# users home directory
environmentConfigurationFileContent = "";
for manualEnvironment in manualEnvironments:
    environmentConfigurationFileContent += manualEnvironment + "\n";
environmentConfigurationFileName = os.path.join(os.path.expanduser("~"), ".dotfiles-environments");
environmentConfigurationFile = open(environmentConfigurationFileName, "w");
environmentConfigurationFile.write(environmentConfigurationFileContent);
environmentConfigurationFile.close();

environmentsRootDirectory = os.path.join(os.path.dirname(os.path.abspath(__file__)), "environments");
print "Installing dotfiles installation from root directory: " + environmentsRootDirectory

# Resolve all the .symlink files (or directories for that matter) and make sure that they are
# correctly linked into the $HOME directory (or a child directory inside the $HOME directory)
globalErrorHandlingMode = None;
for activeEnvironment in activeEnvironments:
    activeEnvironmentDirectory = os.path.join(environmentsRootDirectory, activeEnvironment);
    if os.path.exists(activeEnvironmentDirectory):

        print "Installing dotfiles from environment directory: " + activeEnvironmentDirectory;
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

# Make zsh the default shell
if os.path.basename(os.environ['SHELL']) != "zsh":
    if not subprocess.call("type zsh", shell=True, stdout=subprocess.PIPE, stderr=subprocess.PIPE) == 0:
        print "ZSH cannot be found on this system. I will not change the default shell!"
    elif not subprocess.call("type chsh", shell=True, stdout=subprocess.PIPE, stderr=subprocess.PIPE) == 0:
        print "I can't change your shell automatically because this system does not have chsh."
        print "Please manually change your default shell to zsh!"
    else:
        zshLocation = subprocess.check_output(['which', 'zsh']).strip()
        if subprocess.call(['sudo', 'sh', '-c', 'echo $(which zsh) >> /etc/shells']) == 0:
            print "Cannot add ZSH to /etc/shells"
        if subprocess.call(['chsh', '-s', zshLocation]) == 0:
            print "Default shell changed to zsh (" + str(zshLocation) + "). Restart shell to work with zsh"
        else:
            print "Cannot change default shell to zsh (" + str(zshLocation) + ")"
