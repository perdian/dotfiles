#!/bin/zsh
HYPHEN_INSENSITIVE="true"
COMPLETION_WAITING_DOTS="true"

# If we're on a with with Apple Silicon then Homebrew's `bin` directory isn't on path.
# However we need a couple of commands (e.g. `realpath`) early in the script, so we
# need to make sure early on that what Homebrew offers us is accessible.
if [[ $(uname) == "Darwin" && -f /opt/homebrew/bin/brew ]]; then
  eval "$(/opt/homebrew/bin/brew shellenv)"
fi

# Make sure that the `DOTFILES_HOME` environment variable is available to all subsequent
# operations and scripts so that we have a clear root from which to load all dotfiles
# related content
if [[ -z "${DOTFILES_HOME}" ]]; then
  if which realpath >/dev/null; then
    ZSHRC_LOCATION=$(realpath ~/.zshrc)
    if [[ -e ${ZSHRC_LOCATION} ]]; then
      ZSHRC_DIRECTORY=$(dirname "${ZSHRC_LOCATION}")
      export DOTFILES_HOME=$(realpath "${ZSHRC_DIRECTORY}")
    fi
  fi
fi
if [[ -z "${DOTFILES_HOME}" ]]; then export DOTFILES_HOME="${HOME}/.dotfiles"; fi

# Depending on the type of system we're operating on we need to activate different
# profiles so that certain settings only apply to the systems they're relevant for
DOTFILES_PROFILES=("default")
if [[ $(uname) == "Darwin" ]]; then DOTFILES_PROFILES+=("macos" "macos_$(arch)"); else DOTFILES_PROFILES+=$(uname | tr '[:upper:]' '[:lower:]'); fi

# Make sure all relevant directories are added to the `PATH`
[[ -d /usr/local/bin ]] && export PATH="$PATH:/usr/local/bin"
[[ -d /usr/local/sbin ]] && export PATH="$PATH:/usr/local/sbin"
[[ -d /usr/sbin ]] && export PATH="$PATH:/usr/sbin"
[[ -d /sbin ]] && export PATH="$PATH:/sbin"

# Make sure all relevant directories are added to the `FPATH`
type brew &>/dev/null && FPATH="$(brew --prefix)/share/zsh/site-functions:${FPATH}"

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

# Loop through all the profile directories and activate the profile
DOTFILES_PROFILE_DIRECTORIES=("${DOTFILES_PROFILES[@]/#/${DOTFILES_HOME}/profiles/}" "$(realpath ~/.zshrc.local.d)")
for DOTFILES_PROFILE_DIRECTORY in "${DOTFILES_PROFILE_DIRECTORIES[@]}"; do

  # A `bin` directory inside the profile gets added to the `PATH`
  [[ -d "${DOTFILES_PROFILE_DIRECTORY}/bin" ]] && export PATH="$PATH:${DOTFILES_PROFILE_DIRECTORY}/bin"

  # An `fbin` directory inside the profile gets added to the `fpath`
  [[ -d "${DOTFILES_PROFILE_DIRECTORY}/fbin" ]] && fpath=("${DOTFILES_PROFILE_DIRECTORY}/fbin" $fpath)

  # Source all the files within the profile (and its subfolders) ending in `.zsh`
  for ZSH_FILE in ${DOTFILES_PROFILE_DIRECTORY}/zshrc.d/**/*.zsh(N); do
    source ${ZSH_FILE}
  done

done
unset DOTFILES_PROFILE_DIRECTORY
unset DOTFILES_PROFILE_DIRECTORIES

export dotfiles_info() {
  echo "DOTFILES_HOME:      ${DOTFILES_HOME}"
  echo "DOTFILES_PROFILES:  ${DOTFILES_PROFILES[@]}"
}

export dotfiles_upgrade() {

  echo "Upgrading dotfiles at: ${DOTFILES_HOME}"
  git -C "${DOTFILES_HOME}" pull

  for DOTFILES_PROFILE_DIRECTORY in "${DOTFILES_PROFILE_DIRECTORIES[@]}"; do
    for UPGRADE_FILE in ${DOTFILES_PROFILE_DIRECTORY}/upgrade.d/**/*.zsh(N); do
      source ${UPGRADE_FILE}
    done
    unset UPGRADE_FILE
  done
  unset DOTFILES_PROFILE_DIRECTORY

}
