up() {
    echo "Updating Homebrew"
    brew update && brew upgrade
    echo "Updating Oh My Zsh"
    upgrade_oh_my_zsh
}
