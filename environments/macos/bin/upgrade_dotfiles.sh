#!/usr/local/bin/zsh
echo "Updating Homebrew"
brew update && brew upgrade && brew cleanup

echo "Updating Oh My Zsh"
upgrade_oh_my_zsh

DOTFILES_HOME_RAW="$(dirname $0)/../../../"
DOTFILES_HOME="$(realpath $DOTFILES_HOME_RAW)"
echo "Updating dotfiles in $DOTFILES_HOME"
cd $DOTFILES_HOME
git pull
$DOTFILES_HOME/install.py $(< ~/.dotfiles-environments)
source ~/.zshrc
