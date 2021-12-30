# Overwrite all settings with local settings that may be stored in the users home directory
# which are *not* under version control inside the dotfiles (using the "~/.zshrc.local" directory)
if [[ -d ~/.zshrc.local ]]; then
    for ZSH_FILE in ~/.zshrc.local/**/*.zsh(N); do
        source ${ZSH_FILE}
    done
    for BIN_DIRECTORY in ~/.zshrc.local/**/bin(/N); do
        export PATH="${PATH}:${BIN_DIRECTORY}"
    done
fi
