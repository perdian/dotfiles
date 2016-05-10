#!/bin/sh
if which apt-get >/dev/null; then

    sudo apt-get install dialog git nano zsh coreutils wget autojump software-properties-common python-software-properties realpath

    ALL_APT_GET_REPOSITORIES=$(apt-cache policy)
    if [[ ! "${ALL_APT_GET_REPOSITORIES}" =~ webupd8team/java ]]; then
        sudo add-apt-repository ppa:webupd8team/java
        sudo apt-get update
    fi
    if [[ ! "${ALL_APT_GET_REPOSITORIES}" =~ brightbox/ruby-ng ]]; then
        sudo add-apt-repository ppa:brightbox/ruby-ng
        sudo apt-get update
    fi

    sudo apt-get install oracle-java8-installer
    sudo apt-get install oracle-java8-set-default maven ant ruby2.2 ruby2.2-dev

fi