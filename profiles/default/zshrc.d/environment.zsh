if [[ -f /opt/homebrew/bin/nano ]]; then
  export EDITOR=/opt/homebrew/bin/nano
elif [[ -f /usr/bin/nano ]]; then
  export EDITOR=/usr/bin/nano
elif [[ -f /usr/bin/vim ]]; then
  export EDITOR=/usr/bin/vim
fi
