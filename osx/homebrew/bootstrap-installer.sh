#!/bin/sh
if test "$(uname)" = "Darwin"
then

    if ! which brew >/dev/null; then
         echo "Installing Homebrew for you."
         ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
    fi

    CURRENT_DIRECTORY=`dirname "$0"`
    cd ${CURRENT_DIRECTORY}

    echo "Updating Homebrew"
    brew update

    echo "Importing Brewfile at ${CURRENT_DIRECTORY}/Brewfile"
    brew bundle

    echo "Homebrew update completed"

fi