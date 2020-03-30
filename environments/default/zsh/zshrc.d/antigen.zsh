if [[ $(uname -s) == 'Darwin' ]]; then
  source $(brew --prefix)/share/antigen/antigen.zsh
else
    if [[ ! -f ~/.antigen.zsh ]]; then
      echo "Downloading Antigen"
      curl -L git.io/antigen > ~/antigen.zsh
    fi
    source  ~/antigen.zsh
fi

antigen use oh-my-zsh

if [[ $(uname -s) == 'Darwin' ]]; then
  antigen bundle brew
  antigen bundle osx
fi

antigen bundle bundler
antigen bundle colorize
antigen bundle common-aliases
antigen bundle docker
antigen bundle encode64
antigen bundle fasd
antigen bundle gem
antigen bundle git
antigen bundle git-extras
antigen bundle git-flow
antigen bundle jsontools
antigen bundle sudo
antigen bundle urltools
antigen bundle zsh-users/zsh-autosuggestions
antigen bundle zsh-users/zsh-completions
antigen theme romkatv/powerlevel10k
antigen apply
