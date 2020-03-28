#!/usr/bin/env zsh
if [[ $(uname -s) == 'Darwin' ]]; then
    echo "Upgrading Homebrew"
    brew update
    brew bundle --file $(realpath $(dirname $0))/environments/macos/Brewfile
    brew upgrade && brew cleanup
fi

if which apt-get >/dev/null; then
    sudo apt-get --yes install dialog git vim nano zsh coreutils wget autojump software-properties-common
fi

DOTFILES_HOME="$(realpath $(dirname $0))"
echo "Upgrading dotfiles repository in $DOTFILES_HOME"
cd $DOTFILES_HOME && git pull

echo "Upgrading Oh My Zsh"
source ~/.oh-my-zsh/oh-my-zsh.sh
upgrade_oh_my_zsh

echo "Upgrading Oh My Zsh resources"
for custom_directory in ~/.oh-my-zsh/custom/*/*
do
  if [ -d "${custom_directory}/.git" ]; then
    echo "Upgrading Oh My Zsh custom entry at: ${custom_directory}"
    cd ${custom_directory}/ && git pull
  fi
done

source ~/.zshrc
