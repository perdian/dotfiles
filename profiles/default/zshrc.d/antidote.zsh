export ANTIDOTE_HOME="${DOTFILES_DATA}/antidote/home"
if [[ $(uname -s) == 'Darwin' ]]; then
  source $(brew --prefix)/opt/antidote/share/antidote/antidote.zsh
else
  if [[ ! -d "${DOTFILES_DATA}/antidote/repository/" ]]; then
    echo "Downloading Antidote"
    git clone --depth=1 https://github.com/mattmc3/antidote.git "${DOTFILES_DATA}/antidote/repository"
  fi
  source "${DOTFILES_DATA}/antidote/repository/antidote.zsh"
fi

zstyle ':antidote:bundle' file "${0:A:h}/antidote.plugins.txt"
zstyle ':antidote:static' file "${DOTFILES_DATA}/antidote/antidote.plugins.zsh"
zstyle ':antidote:bundle' use-friendly-names 'yes'
antidote load
