#!/usr/bin/env zsh
echo "Adjusting system defaults"

# Sources and inspiration for settings:
# - https://marketmix.com/de/mac-osx-umfassende-liste-der-terminal-defaults-commands/ (German)
# - https://github.com/holman/dotfiles/blob/master/osx/set-defaults.sh
# - https://github.com/mathiasbynens/dotfiles/blob/master/.macos

# -----------------------------------------------------------------------------
# macOS
# -----------------------------------------------------------------------------

# Font smoothing (see https://colinstodd.com/posts/tech/fix-macos-catalina-fonts-after-upgrade.html)
defaults -currentHost write -globalDomain CGFontRenderingFontSmoothingDisabled -bool FALSE
defaults -currentHost write -globalDomain AppleFontSmoothing -int 2

# Expand save panel by default (see https://www.defaults-write.com/expand-save-panel-default/)
defaults write -globalDomain NSNavPanelExpandedStateForSaveMode -bool TRUE
defaults write -globalDomain NSNavPanelExpandedStateForSaveMode2 -bool TRUE

# Disable smart quotes and smart dashed as they’re annoying when typing code
defaults write -globalDomain NSAutomaticQuoteSubstitutionEnabled -bool FALSE
defaults write -globalDomain NSAutomaticDashSubstitutionEnabled -bool FALSE

# Disable auto-correct
defaults write NSGlobalDomain NSAutomaticSpellingCorrectionEnabled -bool FALSE

# Disable press-and-hold for keys in favor of key repeat
defaults write -globalDomain ApplePressAndHoldEnabled -bool FALSE

# Enabling full keyboard access for all controls (e.g. enable Tab in modal dialogs)
defaults write -globalDomain AppleKeyboardUIMode -int 3

# Stop Photos from opening when a new SD card, etc. is being plugged in (see http://lifehacker.com/prevent-photos-on-os-x-from-opening-up-automatically-1754586297)
defaults write com.apple.ImageCapture disableHotPlug -bool TRUE

# Use AirDrop over every interface
defaults write com.apple.NetworkBrowser BrowseAllInterfaces -bool TRUE

# Disable the “Are you sure you want to open this application?” dialog
defaults write com.apple.LaunchServices LSQuarantine -bool FALSE

# Don't create .DS_Store files on network volumes
defaults write com.apple.desktopservices DSDontWriteNetworkStores -bool TRUE

# Disable the sound effects on boot
sudo nvram SystemAudioVolume=" "


# -----------------------------------------------------------------------------
# Terminal
# -----------------------------------------------------------------------------

# Disable "Last login" message when opening a new shell
touch ~/.hushlogin


# -----------------------------------------------------------------------------
# Finder
# -----------------------------------------------------------------------------

# Show the complete path in the Finder title bar
defaults write com.apple.finder _FXShowPosixPathInTitle -bool TRUE

# Show folders first
defaults write com.apple.finder _FXSortFoldersFirst -bool TRUE

# Disable the warning when changing a file extension
defaults write com.apple.finder FXEnableExtensionChangeWarning -bool FALSE

# Always open everything in list view (see https://www.defaults-write.com/change-default-view-style-in-os-x-finder/)
defaults write com.apple.Finder FXPreferredViewStyle Nlsv

# Disable the warning before emptying the Trash
defaults write com.apple.finder WarnOnEmptyTrash -bool FALSE


# -----------------------------------------------------------------------------
# Safari
# -----------------------------------------------------------------------------

defaults write com.apple.Safari ShowFavoritesBar -bool FALSE
defaults write com.apple.Safari IncludeInternalDebugMenu -bool TRUE
defaults write com.apple.Safari IncludeDevelopMenu -bool TRUE
defaults write com.apple.Safari WebKitDeveloperExtrasEnabledPreferenceKey -bool TRUE
defaults write com.apple.Safari "com.apple.Safari.ContentPageGroupIdentifier.WebKit2DeveloperExtrasEnabled" -bool TRUE
defaults write -globalDomain WebKitDeveloperExtras -bool TRUE


# -----------------------------------------------------------------------------
# Other applications
# -----------------------------------------------------------------------------

# Disable automatic spell checking
defaults write com.apple.mail SpellCheckingBehavior -string "NoSpellCheckingEnabled"
