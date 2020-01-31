#!/usr/local/bin/zsh
if [[ $(uname -s) == 'Darwin' ]]; then
    echo "Upgrading Homebrew"
    brew update && brew upgrade && brew cleanup
fi

DOTFILES_HOME_RAW="$(dirname $0)/../../../"
DOTFILES_HOME="$(realpath $DOTFILES_HOME_RAW)"
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

echo "Applying latest dotfiles configuration"
$DOTFILES_HOME/install.py $(< ~/.dotfiles-environments)
source ~/.zshrc
