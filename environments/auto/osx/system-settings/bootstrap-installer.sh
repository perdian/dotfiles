#!/bin/sh
if test "$(uname)" = "Darwin"
then

    # Install default keybindings
    SOURCE_DIRECTORY="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

    mkdir -p ~/Library/KeyBindings
    cp $SOURCE_DIRECTORY/data/DefaultKeyBinding.dict ~/Library/KeyBindings/

    # Show the complet path in the Finder title bar
    defaults write com.apple.finder _FXShowPosixPathInTitle -bool YES

    # I stole some of the following original ideas from Zach Holman
    # https://github.com/holman/dotfiles/blob/master/osx/set-defaults.sh

    # Disable press-and-hold for keys in favor of key repeat.
    defaults write -g ApplePressAndHoldEnabled -bool false

    # Use AirDrop over every interface. srsly this should be a default.
    defaults write com.apple.NetworkBrowser BrowseAllInterfaces 1

    # Always open everything in Finder's list view. This is important.
    defaults write com.apple.Finder FXPreferredViewStyle Nlsv

    # Configure Safari
    defaults write com.apple.Safari ShowFavoritesBar -bool false
    defaults write com.apple.Safari IncludeInternalDebugMenu -bool true
    defaults write com.apple.Safari IncludeDevelopMenu -bool true
    defaults write com.apple.Safari WebKitDeveloperExtrasEnabledPreferenceKey -bool true
    defaults write com.apple.Safari "com.apple.Safari.ContentPageGroupIdentifier.WebKit2DeveloperExtrasEnabled" -bool true
    defaults write NSGlobalDomain WebKitDeveloperExtras -bool true

    # Stop Photos from opening when a new SD card, etc. is being plugged in
    # http://lifehacker.com/prevent-photos-on-os-x-from-opening-up-automatically-1754586297
    defaults write com.apple.ImageCapture disableHotPlug -bool true

    # More configurations inspired by Mathias Bynens
    # https://github.com/mathiasbynens/dotfiles/blob/master/.osx

    # Disable the “Are you sure you want to open this application?” dialog
    defaults write com.apple.LaunchServices LSQuarantine -bool false

    # Disable the warning before emptying the Trash
    defaults write com.apple.finder WarnOnEmptyTrash -bool false

    # Prevent Photos from opening automatically when devices are plugged in
    defaults -currentHost write com.apple.ImageCapture disableHotPlug -bool true

    # Expand save panel by default
    defaults write NSGlobalDomain NSNavPanelExpandedStateForSaveMode -bool true
    defaults write NSGlobalDomain NSNavPanelExpandedStateForSaveMode2 -bool true

    # Disable automatic spell checking
    defaults write com.apple.mail SpellCheckingBehavior -string "NoSpellCheckingEnabled"

    # Others

    # Disable the sound effects on boot
    sudo nvram SystemAudioVolume=" "

fi
