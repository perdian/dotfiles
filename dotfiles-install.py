#!/usr/bin/env python3
import os
import subprocess
import glob
import shutil
import sys
import fnmatch

# If we're on macOS we ensure that both Homebrew and zsh are installed as these are the two major dependencies for
# initializing the dotfiles
if (sys.platform == "darwin"):
    if not subprocess.call("type brew", shell=True, stdout=subprocess.PIPE, stderr=subprocess.PIPE) == 0:
        print "Installing Homebrew for you"
        homebrewInstallScript = urllib.urlopen("https://raw.githubusercontent.com/Homebrew/install/master/install")
        homebrewInstallContent = homebrewInstallScript.read()
        subprocess.call(["ruby", "-e", homebrewInstallContent])
    if not subprocess.call("type zsh", shell=True, stdout=subprocess.PIPE, stderr=subprocess.PIPE) == 0:
        print "Installing zsh for you"
        subprocess.call(["brew", "install", "zsh"])

# Resolve the environments that should be active
active_environments = [ "default" ]
if (sys.platform == "darwin"):
    active_environments.append("macos")
elif (sys.platform == "linux" or sys.platform == "linux2"):
    active_environments.append("linux")
print "Resolved environments: \033[96m" + str(active_environments) + "\033[0m"

# Lookup the root directory of the dotfiles and start the installation
dotfiles_root_directory = os.path.dirname(os.path.abspath(__file__))
print "Dotfiles root directory: " + dotfiles_root_directory

# Resolve all the .symlink files (or directories for that matter) and make sure that they are
# correctly linked into the $HOME folder (or a child folder inside the $HOME folder)
global_error_handling_mode = None
for active_environment in active_environments:
    active_environment_directory = os.path.join(dotfiles_root_directory, 'environments', active_environment)
    if os.path.exists(active_environment_directory):

        for root, dir_names, file_names in os.walk(active_environment_directory):
            for source_file_name in fnmatch.filter(file_names + dir_names, '*.symlink'):

                sourceFile = os.path.join(root, source_file_name)
                source_file_resolved = os.path.realpath(sourceFile)
                source_file_name = os.path.basename(sourceFile)

                source_file_index_of_symlink = source_file_name.find(".symlink")
                source_file_index_of_target_directory_name = source_file_name.find("@")

                if source_file_index_of_target_directory_name > -1:
                    target_directory_encoded = source_file_name[source_file_index_of_target_directory_name+1:source_file_index_of_symlink]
                    target_directory_name = target_directory_encoded.replace("@", "/")
                    target_directory = os.path.join(os.path.expanduser("~"), target_directory_name)
                    target_file_name = source_file_name[0:source_file_index_of_target_directory_name]
                else:
                    target_directory = os.path.expanduser("~")
                    target_file_name = source_file_name[0:source_file_index_of_symlink]

                target_file = os.path.join(target_directory, target_file_name)
                target_file_resolved = os.path.realpath(target_file)

                if os.path.exists(target_file_resolved) and source_file_resolved == target_file_resolved:

                    # The source file exists and already represents a link to the target file so there is nothing that we need to do.
                    print "\033[2mTarget '" + str(target_file) + " already symlinked to '" + str(source_file_resolved) + "'\033[0m"

                elif not os.path.exists(target_file_resolved):

                    if os.path.islink(target_file):
                        os.unlink(target_file)

                    target_fileParent = os.path.abspath(os.path.join(target_file_resolved, os.pardir))
                    if not os.path.exists(target_fileParent):
                        os.makedirs(target_fileParent)

                    os.symlink(sourceFile, target_file)
                    print "Symlinked '" + str(target_file) + "' to '" + str(source_file_resolved) + "'"

                else:

                    # The target file already exists and is not identical with the file that we would like to place there.
                    # We need to ask the user what to do now.
                    if global_error_handling_mode == None:
                        print "Target file '" + str(target_file) + "' is already existing. What do you want to do?"
                        print "[s]kip, [S]kip all, [o]verwrite, [O]verwrite all, [b]ackup, [B]ackup all?"
                        error_handling_mode_result = raw_input(">> ")
                        if len(error_handling_mode_result) > 0 and error_handling_mode_result == error_handling_mode_result.upper():
                            global_error_handling_mode = error_handling_mode_result.lower()
                        error_handling_mode = error_handling_mode_result.lower()
                    else:
                        error_handling_mode = global_error_handling_mode

                    if error_handling_mode == "s" or error_handling_mode == "":
                        pass
                    elif error_handling_mode == "o":
                        if os.path.isdir(target_file):
                            shutil.rmtree(target_file)
                        elif os.path.isfile(target_file):
                            os.remove(target_file)
                        os.symlink(sourceFile, target_file)
                        print "Symlinked '" + str(target_file) + "' to '" + str(source_file_resolved) + "'"
                    elif error_handling_mode == 'b':
                        backupFile = target_file + ".backup"
                        print "Moving '" + str(target_file) + "' to '" + str(backupFile) + "'"
                        shutil.move(target_file, backupFile)
                        os.symlink(sourceFile, target_file)
                        print "Symlinked '" + str(target_file) + "' to '" + str(source_file_resolved) + "'"

# Make zsh the default shell
if 'SHELL' not in os.environ or os.path.basename(os.environ['SHELL']) != "zsh":
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
