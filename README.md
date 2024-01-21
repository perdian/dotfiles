# perdian does dotfiles

In the good old days I managed all my personal configurations and scripts manually.
Then I got tired of setting up the same things over and over when switching to a new or different computer.
Keeping my personal machine, my working machine, my personal server as identical as possible became quite cumbersome.

So there came the time when I wanted to automate the whole stuff as much as possible.
This dotfiles project is the result (or let's call it work in progress) of me wanting to have all my stuff both versioned and easy to access at any time from any location.

As with many projects I'm standing on the shoulders of great people and have recklessly copied ideas and configurations from many sources, most prominently [Zach Holman](https://github.com/holman/dotfiles) and [Ryan Bates](https://github.com/ryanb/dotfiles).

## What's inside

My personal collection of shell scripts, configuration files and other resources also known as *dofiles*.

They're first and foremost designed to work on macOS, as that's my primary operating system both on my personal machine and my working machine. Second class support is given to Linux as that's what my personal server is running on.

The project itself is not really designed to be used "as is" by anyone else but may serve as an idea of how *your* personal dotfiles could be structured. I'm far from suggesting that my stuff works for everybody - but if you do find it interesting [fork it](https://github.com/perdian/dotfiles/fork), remove what you don't use, and build on what you *do* want to use.

## Profiles

Not *all* dotfiles apply to *all* my machines.
Some scripts are only relevant on a macOS machine while others are only relevant on a Linux machine.

To achieve this the dotfiles are grouped into *profiles*.

All profile specific scripts and settings are stored inside the `profiles` folder. Each subfolder within the `profiles` folder represents a separate set of dotfiles specific to that profile.

A profile becomes active (and thus all dotfiles of that profile will be included) depending on the following *profile activation criteria*:

- The `default` profile will always be activated.
- The `macos` profile will be activated if the `.zshrc` initialization script discovers that it's running on macOS.
    - The `macos_arm64` and `macos_i386` profiles will be activated depending on the macOS architecture.
- The `linux` profile will be activated if the `.zshrc` initialization script discovers that it's running on Linux.

An additional profile will be activated residing a `~/.zshrc.local.d`.
This directory behaves exactly like any other profile directory, but it has been deliberately chosen to *not* be residing inside the folder structure of this dotfiles project so that additional configurations and settings for specific machines can be added outside the version control scope of this dotfiles project.

### Components

There are a few special folders and files inside the hierarchy.

- **profiles/PROFILE_NAME/bin/**: The `bin/` folder of a profile will be appended to the `$PATH`.
- **profiles/PROFILE_NAME/fbin/**: The `fbin/` folder of a profile will be prepended to the `fpath`.
- **profiles/PROFILE_NAME/zshrc.d/\*\*/\*.zsh**: All files ending with `.zsh` will get loaded into the shell environment.
- **profiles/PROFILE_NAME/home/**: All files within the `home` directory will get symlinked into their corresponding files below the current users home directory (`~`). So for example the file `~/.dotfiles/profiles/PROFILE_NAME/home/Library/Application Support/karabiner` will be translated to the actual target folder `~/Library/Application Support/karabiner`. The symlinks will be created/updated each time a new ZSH shell is opened.

### Installation

Checkout the repository to any location on your local system (e.g. the `.dotfiles` in your home folder) and link the `.zshrc` file to your local `.zshrc` file. Opening a new ZSH shell will initialize everything.

#### macOS

The preparations for macOS differ slightly as Homebrew is installed in different directories on Intel Macs and Apple Silicon Macs.

##### Prepare a fresh macOS installation (Apple Silicon)

```shell
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
/opt/homebrew/bin/brew install coreutils git direnv antigen curl fzf
```

##### Prepare a fresh macOS installation (Intel)

```shell
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
/usr/local/bin/brew install coreutils git direnv antigen curl
```

##### Install dotfiles

```shell
git clone https://github.com/perdian/dotfiles.git ~/.dotfiles
ln -s -f ~/.dotfiles/.zshrc ~/.zshrc
```

The necessary dependencies will be installed automatically when opening a new ZSH shell.

To update the Homebrew bundles (and install additional bundles) after the installation execute the following command:

```shell
dotfiles_upgrade
```

#### Linux

Some necessary system tools might be missing, so to be on the safe side make sure to install the following system components before calling the install script:

```shell
sudo apt -y install dialog curl git zsh python3 vim fzf nano direnv
git clone https://github.com/perdian/dotfiles.git ~/.dotfiles
ln -s -f ~/.dotfiles/.zshrc ~/.zshrc
sudo chsh -s /bin/zsh
```
