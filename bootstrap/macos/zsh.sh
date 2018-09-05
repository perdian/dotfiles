#!/bin/sh
if [ ! -d $HOME/.oh-my-zsh ] ; then
    echo "Installing Oh My ZSH"
    git clone --depth=1 https://github.com/robbyrussell/oh-my-zsh.git $HOME/.oh-my-zsh
fi
if [ ! -d $HOME/.oh-my-zsh/custom/themes/powerlevel9k ] ; then
    echo "Installing powerlevel9k theme for Oh My ZSH"
    git clone --depth=1 https://github.com/bhilburn/powerlevel9k.git $HOME/.oh-my-zsh/custom/themes/powerlevel9k
fi

TEST_CURRENT_SHELL=$(expr "$SHELL" : '.*/\(.*\)')
if [ "$TEST_CURRENT_SHELL" != "zsh" ]; then
    if hash chsh >/dev/null 2>&1; then
        chsh -s $(grep /zsh$ /etc/shells | tail -1)
    else
        echo "I can't change your shell automatically because this system does not have chsh."
        echo "Please manually change your default shell to zsh!"
    fi
    echo "Restart shell to work with zsh"
fi
