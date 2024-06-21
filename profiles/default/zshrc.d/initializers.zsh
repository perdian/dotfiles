[[ -x "$(command -v direnv)" ]] && eval "$(direnv hook zsh)"
[[ -x "$(command -v rbenv)" ]] && eval "$(rbenv init -)"
[[ -x "$(command -v zoxide)" ]] && eval "$(zoxide init zsh)"
[[ -x "$(command -v ng)" ]] && eval "$(ng completion script)"
