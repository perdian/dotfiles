echo "Applying system defaults"
echo "(Make sure the terminal app where you execute this script has full disk access)"

# Font smoothing (see https://colinstodd.com/posts/tech/fix-macos-catalina-fonts-after-upgrade.html)
defaults -currentHost write -globalDomain AppleFontSmoothing -int 0

# Expand save panel by default (see https://www.defaults-write.com/expand-save-panel-default/)
defaults write -globalDomain NSNavPanelExpandedStateForSaveMode -bool TRUE
defaults write -globalDomain NSNavPanelExpandedStateForSaveMode2 -bool TRUE

# Expand print panel by default
defaults write NSGlobalDomain PMPrintingExpandedStateForPrint -bool TRUE
defaults write NSGlobalDomain PMPrintingExpandedStateForPrint2 -bool TRUE

# Disable smart quotes and smart dashed as they’re annoying when typing code
defaults write -globalDomain NSAutomaticQuoteSubstitutionEnabled -bool FALSE
defaults write -globalDomain NSAutomaticDashSubstitutionEnabled -bool FALSE

# Disable auto-correct
defaults write -globalDomain NSAutomaticSpellingCorrectionEnabled -bool FALSE

# Disable press-and-hold for keys in favor of key repeat
defaults write -globalDomain ApplePressAndHoldEnabled -bool FALSE

# Always show the scrollbars
defaults write -globalDomain AppleShowScrollBars -string Always
# Possible values: `WhenScrolling`, `Automatic` and `Always`

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

# Disable shadows in screenshots
defaults write com.apple.screencapture "disable-shadow" -bool TRUE

# Write screenshots to ~/Downloads
defaults write com.apple.screencapture "location" -string "~/Downloads"

# Restore small cursor
sudo defaults write /Library/Preferences/FeatureFlags/Domain/UIKit.plist redesigned_text_cursor -dict-add Enabled -bool NO

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
# Apple Mail
# -----------------------------------------------------------------------------

# Don't show attachments inline when composing a new message
defaults write com.apple.mail DisableInlineAttachmentViewing -boolean yes

# -----------------------------------------------------------------------------
# Other applications
# -----------------------------------------------------------------------------

defaults write -globalDomain WebKitDeveloperExtras -bool TRUE
