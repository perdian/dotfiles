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
