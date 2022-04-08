# Make sure that all the symlinks that are expected to be in place are actually be in place.
# This ensures that if the dotfiles repository has been updated and introduced new symlinks that these
# are created before any other scripts are run.
for DOTFILES_PROFILE in "${DOTFILES_PROFILES[@]}"; do
  if [[ -n "${DOTFILES_PROFILE}" ]]; then
    for TARGET_FILE in ${DOTFILES_HOME}/zsh/profiles/${DOTFILES_PROFILE}/**/*.symlink(.DN); do

      TARGET_FILE_NAME=$(basename ${TARGET_FILE})
      SYMLINK_FILE_NAME=$(echo ${TARGET_FILE_NAME%".symlink"} | tr '@' '/')
      SYMLINK_FILE="$(realpath ${HOME})/${SYMLINK_FILE_NAME}"

      if [[ ${TARGET_FILE} -ef ${SYMLINK_FILE} ]]; then
        # The symlink already exists and points to the correct file.
        # Best case scenario, nothing we need to do.
      else
        if [[ -f ${SYMLINK_FILE} ]]; then
          # A file already exists at the location where we want to create the symlink.
          # We rename that existing file and append the ".old" extension so that we can
          # create the link to "our" target file
          echo "\033[1;30mRenaming already existing file '${SYMLINK_FILE}' for dotfiles symlink to '$(basename ${SYMLINK_FILE}).old'\e[0m"
          mv -f "${SYMLINK_FILE}" "${SYMLINK_FILE}.old"
        fi
        echo "\033[1;30mCreating new dotfiles symlink at '${SYMLINK_FILE}' pointing to '${TARGET_FILE}'\e[0m"
        mkdir -p "$(dirname ${SYMLINK_FILE})"
        ln -s -f "${TARGET_FILE}" "${SYMLINK_FILE}"
      fi

    done
  fi
done
