# Introduction

This file contains the steps needed for me to setup up a completely new machine.
It's designed to require a minimum amount of manual work and have install most of my applications scripted with only those that aren't scriptable (yet) by hand.

# Initial system bootstrap

To setup a completely new machine with my default values (or to update an already existing machine) I can simply call the dotfils install and update scripts:

```shell
$ git clone https://github.com/perdian/dotfiles.git ~/.dotfiles
$ ~/.dotfiles/dotfiles install
$ ~/.dotfiles/dotfiles update
$ ~/.dotfiles/dotfiles macos # if running on a macOS machine
```

# Manual steps after initial bootstrap

## System settings

* Adjust Mouse and Keyboard (Repeat rate, etc.)
* Adjust Dock (Size, behaviour, applications, etc.)

## Install additional applications

Install and configure applications that could not be installed automatically

* Install BetterTouchTool + license

## Configure applications

Configure the applications that were installed automatically by the `install.py` script

* iTerm
    * Import preferences from Dropbox
    * Adjust default profile
        * Adjust font for powerlevel (Literation Mono Powerline)
        * Adjust default window size (110x30)
* Scrivener
    * Install license
* 1Password
    * Install license
* Dash
    * Install license
* Firefox
    * Make default browser
    * Import default bookmarks
* BetterTouchTool
    * Mouse scrolling, special keys
* Fluor
    * Install on system start
    * Select applications to permanently use F-Keys
* Spark
    * Setup email account
* Slack
    * Setup account(s)
* Amphetamine
    * Install on system start
* Monosnap
    * Install on system start
* Contexts
    * Setup appereance
    * Enable system access
    * Install on system start
* Firefox
    * Install addons
        * uBlock origin: https://addons.mozilla.org/de/firefox/addon/ublock-origin/
        * Tampermonkey: https://addons.mozilla.org/de/firefox/addon/tampermonkey/
        * Cookies: https://addons.mozilla.org/de/firefox/addon/cookiesnew/
        * Default bookmark folder: https://addons.mozilla.org/de/firefox/addon/default-bookmark-folder/
        * Disable JavaScript: https://addons.mozilla.org/de/firefox/addon/disable-javascript/
        * Reload in address bar: https://addons.mozilla.org/de/firefox/addon/reload-in-address-bar/
        * Enhancer for YouTube: https://addons.mozilla.org/de/firefox/addon/enhancer-for-youtube/
    * Install bookmarks from [firefox-bookmarks.html](resources/firefox-bookmarks.html)
* Itsycal
    * Install on system start
* The Unarchiver
    * Install for file types
* F.lux
    * Install on system start
