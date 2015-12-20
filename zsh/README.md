# Installation (after installing zsh and oh-my-zsh)
https://github.com/robbyrussell/oh-my-zsh

    brew install zsh
    sh -c "$(curl -fsSL https://raw.github.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"

Replace `.zshrc` profile file with the following content:

    source $HOME/Dropbox/Shared/Dotfiles/zsh/zshrc.symlink

All files in `zsh.d` files will be sourced after oh-my-zsh is loaded.

