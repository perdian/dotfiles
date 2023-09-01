#!/usr/bin/env zsh
echo "Upgrading dotfiles at: ${DOTFILES_HOME}"

echo "Upgrading dotfiles repository in ${DOTFILES_HOME}"
cd ${DOTFILES_HOME} && git pull

if [[ $(uname -s) == 'Darwin' ]]; then
  echo "Upgrading Homebrew"
  brew update
  brew bundle -v --file ${DOTFILES_HOME}/bundles/macos/Brewfile
  brew upgrade && brew cleanup
fi

if which apt-get >/dev/null; then
  sudo apt-get --yes install dialog git vim nano zsh coreutils wget software-properties-common
fi

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
