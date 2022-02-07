#!/bin/bash

echo "Cloning dotfiles repository from GitHub"
git clone https://github.com/perdian/dotfiles.git ~/.dotfiles

if ! [[ ~/.dotfiles/zsh/.zshrc.symlink -ef ~/.zshrc ]]; then
  echo "Setting up .zshrc from dotfiles"
  [[ -f ~/.zshrc ]] && mv -f ~/.zshrc ~/.zshrc.old
  ln -s -f ~/.dotfiles/zsh/.zshrc.symlink ~/.zshrc
fi

if [[ $(basename ${SHELL}) != "zsh" ]]; then
  if ! type zsh > /dev/null 2> /dev/null; then
    echo "ZSH is not available on this system! Will not change the default shell!"
  elif ! type chsh > /dev/null 2> /dev/null; then
    echo "I can't change your shell automatically because this system does not have chsh."
    echo "Please manually change your default shell to zsh!"
  else
    echo "Setting up ZSH as default shell"
    chsh -s $(which zsh)
    echo "Default shell changed to zsh. Restart shell to work with zsh"
  fi
else
  echo "Dotfile setup. Open a new shell to see them in effect."
fi
