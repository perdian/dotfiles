dotfiles_update() {

  ${DOTFILES_HOME}/install

  echo "\nExecuting update scripts for profiles"
  for DOTFILES_PROFILE_DIRECTORY in "${DOTFILES_PROFILE_DIRECTORIES[@]}"; do
    for DOTFILES_UPDATE_SCRIPT in ${DOTFILES_PROFILE_DIRECTORY}/update.d/**/*.zsh(.DN); do
      echo "» Executing update script at: ${DOTFILES_UPDATE_SCRIPT}"
      source "${DOTFILES_UPDATE_SCRIPT}"
    done
  done

}
