alias pubkey="cat ~/.ssh/id_ed25519.pub | pbcopy && echo '=> Public key copied to pasteboard.'"

alias cdd="cd ~/Downloads"

if command -v gls >/dev/null 2>&1; then
  alias ls="gls -h --color=auto --time-style=long-iso"
else
  alias ls="ls -hG"
fi
