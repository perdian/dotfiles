# Fail immediately if the DOTFILES_HOME isn't setup correctly
[[ -z "${DOTFILES_HOME}" ]] && export DOTFILES_HOME="${HOME}/.dotfiles"
if [[ ! -d "${DOTFILES_HOME}" ]]; then
  echo "\e[31mDOTFILES_HOME not existing at directory: ${DOTFILES_HOME}\e[0m"
  return 1
fi

# Source all the modules so that they are available for any further script executions
for DOTFILES_BOOTSTRAP_MODULE_FILE in ${DOTFILES_HOME}/bootstrap/**/*(.DN); do
  source ${DOTFILES_BOOTSTRAP_MODULE_FILE}
done
unset DOTFILES_BOOTSTRAP_MODULE_FILE

# Make sure all relevant directories are added to the `PATH`
[[ -d /usr/local/bin ]] && export PATH="$PATH:/usr/local/bin"
[[ -d /usr/local/sbin ]] && export PATH="$PATH:/usr/local/sbin"
[[ -d /usr/sbin ]] && export PATH="$PATH:/usr/sbin"
[[ -d /sbin ]] && export PATH="$PATH:/sbin"

# Make sure that all the symlinks expected to be in place are actually be in place.
# This ensures that if the dotfiles repository has been updated and introduced new
# symlinks that these are created before any other scripts are run.
for DOTFILES_PROFILE in "${DOTFILES_PROFILES[@]}"; do
  DOTFILES_PROFILE_HOME_TARGET_DIRECTORY="${DOTFILES_HOME}/profiles/${DOTFILES_PROFILE}/home"
  for DOTFILES_PROFILE_HOME_TARGET_FILE in ${DOTFILES_PROFILE_HOME_TARGET_DIRECTORY}/**/*(.DN); do

    DOTFILES_PROFILE_HOME_SYMLINK_FILE_NAME="${DOTFILES_PROFILE_HOME_TARGET_FILE#${DOTFILES_PROFILE_HOME_TARGET_DIRECTORY}/}"
    DOTFILES_PROFILE_HOME_SYMLINK_FILE=$(realpath "${HOME}")/${DOTFILES_PROFILE_HOME_SYMLINK_FILE_NAME}

    if [[ ${DOTFILES_PROFILE_HOME_TARGET_FILE} -ef ${DOTFILES_PROFILE_HOME_SYMLINK_FILE} ]]; then
      # The symlink already exists and points to the correct file.
      # Best case scenario, nothing we need to do.
    else
      if [[ -f ${DOTFILES_PROFILE_HOME_SYMLINK_FILE} ]]; then
        # A file already exists at the location where we want to create the symlink.
        # We rename that existing file and append the `.old` extension so that we can
        # create the link to "our" target file
        echo "\033[1;30mRenaming already existing file '${DOTFILES_PROFILE_HOME_SYMLINK_FILE}' for dotfiles symlink to '$(basename ${DOTFILES_PROFILE_HOME_SYMLINK_FILE}).old'\e[0m"
        mv -f "${DOTFILES_PROFILE_HOME_SYMLINK_FILE}" "${DOTFILES_PROFILE_HOME_SYMLINK_FILE}.old"
      fi
      echo "\033[1;30mCreating new dotfiles symlink at '${DOTFILES_PROFILE_HOME_SYMLINK_FILE}' pointing to '${DOTFILES_PROFILE_HOME_TARGET_FILE}'\e[0m"
      mkdir -p "$(dirname ${DOTFILES_PROFILE_HOME_SYMLINK_FILE})"
      ln -s -f "${DOTFILES_PROFILE_HOME_TARGET_FILE}" "${DOTFILES_PROFILE_HOME_SYMLINK_FILE}"
    fi

    unset DOTFILES_PROFILE_HOME_SYMLINK_FILE_NAME
    unset DOTFILES_PROFILE_HOME_SYMLINK_FILE

  done
  unset DOTFILES_PROFILE_HOME_TARGET_FILE
  unset DOTFILES_PROFILE_HOME_TARGET_DIRECTORY
done
unset DOTFILES_PROFILE

# Loop through all the profile directories and activate the profiles by sourcing relevant files
for DOTFILES_PROFILE_DIRECTORY in "${DOTFILES_PROFILE_DIRECTORIES[@]}"; do
  for ZSH_FILE in ${DOTFILES_PROFILE_DIRECTORY}/zshrc.d/**/*.zsh(N); do
    source ${ZSH_FILE}
  done
done
unset DOTFILES_PROFILE_DIRECTORY
