export HYPHEN_INSENSITIVE="true"
export COMPLETION_WAITING_DOTS="true"

# If we're on a machine with Apple Silicon then Homebrew's `bin` directory isn't on path.
# However we need a couple of commands (e.g. `realpath`) early in the script, so we need
# to make sure early on that what Homebrew offers us is accessible.
if [[ $(uname) == "Darwin" && -f /opt/homebrew/bin/brew ]]; then
  eval "$(/opt/homebrew/bin/brew shellenv)"
fi

# Make sure that the `DOTFILES_HOME` environment variable is available to all subsequent
# operations and scripts so that we have a clear root from which to load all dotfiles
# related content
if [[ -z "${DOTFILES_HOME}" ]]; then
  if which realpath >/dev/null; then
    ZSHENV_LOCATION=$(realpath ~/.zshenv)
    if [[ -e ${ZSHENV_LOCATION} ]]; then
      ZSHENV_DIRECTORY=$(dirname "${ZSHENV_LOCATION}")
      export DOTFILES_HOME=$(realpath "${ZSHENV_DIRECTORY}")
      unset ZSHENV_DIRECTORY
    fi
    unset ZSHENV_LOCATION
  fi
fi
if [[ -z "${DOTFILES_HOME}" ]]; then export DOTFILES_HOME="${HOME}/.dotfiles"; fi

# Depending on the type of system we're operating on we need to activate different
# profiles so that certain settings only apply to the systems they're relevant for
DOTFILES_PROFILES=("default")
if [[ $(uname) == "Darwin" ]]; then DOTFILES_PROFILES+=("macos"); else DOTFILES_PROFILES+=$(uname | tr '[:upper:]' '[:lower:]'); fi

# Compute the directories for all the profiles and activate them
DOTFILES_PROFILE_DIRECTORIES=("${DOTFILES_PROFILES[@]/#/${DOTFILES_HOME}/profiles/}" "$(realpath ~/.dotfiles-local-profile/ 2> /dev/null)")

# Source the contents of all relevant profiles
for DOTFILES_PROFILE_DIRECTORY in "${DOTFILES_PROFILE_DIRECTORIES[@]}"; do

  # A `bin` directory inside the profile gets added to the `PATH`
  [[ -d "${DOTFILES_PROFILE_DIRECTORY}/bin" ]] && export PATH="$PATH:${DOTFILES_PROFILE_DIRECTORY}/bin"

  # An `fbin` directory inside the profile gets added to the `fpath`
  [[ -d "${DOTFILES_PROFILE_DIRECTORY}/fbin" ]] && fpath=("${DOTFILES_PROFILE_DIRECTORY}/fbin" $fpath)

  # Source all the files within the profile (and its subfolders) ending in `.zsh`
  for ZSH_FILE in ${DOTFILES_PROFILE_DIRECTORY}/zshenv.d/**/*.zsh(N); do
    source ${ZSH_FILE}
  done

done
unset DOTFILES_PROFILE_DIRECTORY
