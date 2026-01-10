echo "Upgrading Homebrew"
brew update
brew bundle --file "${DOTFILES_HOME}/profiles/macos/Brewfile"
brew upgrade && brew cleanup
