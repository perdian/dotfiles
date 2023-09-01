if [[ -d ${DOTFILES_HOME} ]]; then
  for DOTFILES_PROFILE in "${DOTFILES_PROFILES[@]}"; do
    if [[ -n "${DOTFILES_PROFILE}" ]]; then

      # If we can find a "bin" directory within the profile then we make it part of the path
      if [[ -d ${DOTFILES_HOME}/zsh/profiles/${DOTFILES_PROFILE}/bin ]]; then
        export PATH="$PATH:${DOTFILES_HOME}/zsh/profiles/${DOTFILES_PROFILE}/bin"
      fi

      # If we can find a "fbin" directory within the profile then we make it part of the fpath
      if [[ -d ${DOTFILES_HOME}/zsh/profiles/${DOTFILES_PROFILE}/fbin ]]; then
        fpath=(${DOTFILES_HOME}/zsh/profiles/${DOTFILES_PROFILE}/fbin $fpath)
      fi

      # Source all the files within the profile (and its subfolders) ending in ".zsh"
      for ZSH_FILE in ${DOTFILES_HOME}/zsh/profiles/${DOTFILES_PROFILE}/**/*.zsh(N); do
        source ${ZSH_FILE}
      done

    fi
  done
fi
