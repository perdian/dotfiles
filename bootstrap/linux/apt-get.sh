#!/bin/sh
if which apt-get >/dev/null; then
    sudo apt-get --yes install dialog git vim nano zsh coreutils wget autojump software-properties-common python-software-properties realpath
fi
