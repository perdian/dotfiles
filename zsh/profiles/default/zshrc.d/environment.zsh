if [[ -f /usr/local/bin/nano ]]; then
    export EDITOR=/usr/local/bin/nano
elif [[ -f /usr/bin/nano ]]; then
    export EDITOR=/usr/bin/nano
else
    export EDITOR=/usr/bin/vim
fi
