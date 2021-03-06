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

echo "Upgrading Antigen"
if [[ $(uname -s) == 'Darwin' ]]; then
  source $(brew --prefix)/share/antigen/antigen.zsh
else
    if [[ ! -f ~/.antigen.zsh ]]; then
      echo "Downloading Antigen"
      curl -L git.io/antigen > ~/.antigen.zsh
    fi
    source  ~/.antigen.zsh
fi
antigen update

source ~/.zshrc
