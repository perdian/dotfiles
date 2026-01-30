if [[ ! -d "${DOTFILES_DATA}/fzf/" ]]; then
  git clone --depth 1 https://github.com/junegunn/fzf.git "${DOTFILES_DATA}/fzf/"
  ${DOTFILES_DATA}/fzf/install --bin --key-bindings --completion --no-update-rc --no-zsh --no-bash
fi
PATH="${DOTFILES_DATA}/fzf/bin:$PATH"
source <(${DOTFILES_DATA}/fzf/bin/fzf --zsh)
