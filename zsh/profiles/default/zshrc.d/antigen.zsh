if [[ $(uname -s) == 'Darwin' ]]; then
    source $(brew --prefix)/share/antigen/antigen.zsh
else
    if [[ ! -f ~/antigen.zsh ]]; then
        echo "Downloading Antigen"
        curl -L https://raw.githubusercontent.com/zsh-users/antigen/master/bin/antigen.zsh > ~/antigen.zsh
    fi
    source  ~/antigen.zsh
fi

antigen use oh-my-zsh

if [[ $(uname -s) == 'Darwin' ]]; then
    antigen bundle macos
fi

antigen bundle bundler
antigen bundle colored-man-pages
antigen bundle colorize
antigen bundle common-aliases
antigen bundle encode64
antigen bundle gem
antigen bundle git
antigen bundle gitfast
antigen bundle jsontools
antigen bundle urltools
antigen bundle zsh-users/zsh-autosuggestions
antigen bundle zsh-users/zsh-completions
antigen bundle zsh-users/zsh-syntax-highlighting
antigen bundle Aloxaf/fzf-tab
antigen bundle Tarrasch/zsh-bd
antigen bundle wfxr/forgit

antigen theme romkatv/powerlevel10k

antigen apply
