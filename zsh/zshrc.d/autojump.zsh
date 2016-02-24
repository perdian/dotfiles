# Enable Autojump
if which brew >/dev/null; then
    [[ -s $(brew --prefix)/etc/profile.d/autojump.sh ]] && . $(brew --prefix)/etc/profile.d/autojump.sh
else
    if [ -e /usr/share/autojump/autojump.sh ] ; then
        . /usr/share/autojump/autojump.zsh
    fi
fi