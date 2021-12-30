# Compute the environments that are active so we can use them to filter further initialization
# steps correctly
DOTFILES_PROFILES=("default")
if [[ $(uname) == "Darwin" ]]; then DOTFILES_PROFILES+="macos"; else DOTFILES_PROFILES+=$(uname | tr '[:upper:]' '[:lower:]') fi
