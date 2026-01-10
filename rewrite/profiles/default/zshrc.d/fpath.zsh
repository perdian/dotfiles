# Make sure all relevant directories are added to the `FPATH`
[[ -f /opt/homebrew/bin/brew ]] && FPATH="$(/opt/homebrew/bin/brew --prefix)/share/zsh/site-functions:${FPATH}"
