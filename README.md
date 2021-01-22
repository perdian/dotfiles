# perdian does dotfiles

In the good old days I managed all my personal configurations and scripts manually.
Then I got tired of setting up the same things over and over when switching to a new or different computer.
Keeping my personal machine, my working machine, my personal server as identical as possible became quite cumbersome.

So there came the time when I wanted to automate the whole stuff as much as possible.
This dotfiles project is the result (or let's call it work in progress) of me wanting to have all my stuff both versioned and easy to access at any time from any location.

As with many projects I'm standing on the shoulders of great people and have recklessly copied ideas and configurations from many sources, most prominently [Zach Holman](https://github.com/holman/dotfiles) and [Ryan Bates](https://github.com/ryanb/dotfiles).

## What's inside

My personal collection of shell scripts, configuration files and other resources also known as *dofiles*.

They're first are foremost designed to work on macOS, as that's my primary operating system both on my personal machine and on my working machine. Second class support is given to Linux as that's what my personal servers are running on.

The project itself is not really designed to be used "as is" by anyone else but could serve as an idea of how *your* personal dotfiles could be structured. I'm far from suggesting that my stuff works for everybody but if you find it interesting [fork it](https://github.com/perdian/dotfiles/fork), remove what you don't use, and build on what you *do* want to use.

## Environments

Not *all* dotfiles apply to *all* my machines.
Some scripts are only relevant on a macOS machine while others are only relevant on a Linux machine.

To achieve this the dotfiles are groups by *environment*.

All environment specific scripts and settings are stored inside the `environments` folder. Each subfolder within the `environments` folder represents a separate set of dotfiles specific to that environment.

An environment becomes active (and thus all dotfiles of that environment will be included) depending on the following *environment selection criteria*:

- The `default` environment will be selected each and every time.
- The `macos` and `linux` environments will be if the initialization script discovers that it's running on macOS or Linux respectively.

### Topics

The individual configuration files, resources and scripts inside each environment are grouped around *topic areas*.
Each topic area is represented by its own subfolder within the folder of the relevant environment.

### Components

There are a few special folders and files inside the hierarchy.

- **environments/ENVIRONMENT_NAME/\*\*/bin/\***: Anything in a `bin/` folder will get added to the `$PATH`.
- **environments/ENVIRONMENT_NAME/\*\*/\*.zsh**: All files ending with `.zsh` will get loaded into the shell environment.
- **environments/ENVIRONMENT_NAME/\*\*/\*.symlink**: All files ending in `.symlink` will get symlinked into a target folder below the home folder (or the home folder itself). The part between an (optional) 'at' character and the `.symlink` extension will determine the exact target folder below the users home folder. If no explicit target folder is given (the extension being just `.symlink`) then the link will be created directly inside the users home folder (`$HOME`). Otherwise the part between the 'at' character and the `.symlink` extension will be translated into a folder below the home directory, where all 'at' characters will be replaced by forward slashes. So for example the file `private.xml@Library@Application Support@karabiner.symlink` will be translated to the actual target folder `~/Library/Application Support/karabiner`. This enables me to keep all of my files versioned in the dotfiles but still keep those autoloaded files in my home folder. The symlinks will be created when running the `install` script.

### Coexistence with other local settings

There are some settings that I want to have on a particular machine only which are not checked in into the dotfiles project itself.
The `.zshrc` symlink however is created by the dotfiles installer I need another way to make additional local configurations available.
To support this setup, a special folder `.zshrc.local` can be created inside the users home folder.
This is handled as an additional environment (including topic folders) which will be selected automatically following the rules already layed out in the components section:

- **~/.zshrc.local/\*\*/bin/\***: Anything in a `bin/` folder will get added to the `$PATH`.
- **~/.zshrc.local/\*\*/\*.zsh**: All files ending with `.zsh` will get loaded into the shell environment.

### Installation

Checkout the repository to any location on your local system (e.g. the `.dotfiles` in your home folder) and call the dotfiles script (`dotfiles install`) which will setup all the necessary resources.

Initially this will symlink the appropriate files in the `.dotfiles` folder to your home folder.
Everything will be configured and tweaked within `~/.dotfiles` (or wherever your choose to checkout the repository into).

#### macOS

```shell
$ git clone https://github.com/perdian/dotfiles.git ~/.dotfiles
$ ~/.dotfiles/dotfiles install
```

The necessary dependencies will be installed automatically by the install script, making sure [Homebrew](https://brew.sh/index) is installed and downloading all additional resources through Homebrew.

#### Linux

Some necessary system tools might be missing, so to be on the safe side make sure to install the following system components before calling the install script:

```shell
$ sudo apt-get install dialog curl git zsh python3 vim fzf 
$ /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/perdian/dotfiles/master/install.sh)"
```

## Design decisions

### Python

The `install.py` script itself (as well as some other scripts inside the dotfiles) is written in Python.
The main reason for choosing Python was that I didn't want to use bash scripting (for me it's cumbersome, complicated and simply doesn't feel good) and was looking for a language that was available on the target platforms without an extensive manual installation.

As an additional "bonus" Python is something that I usually don't use professionally so from time to time it gives me a chance to see development concepts from another language.

There are other languages used as well (and yes, even bash scripts) since in the end things should simply work without placing *too* much emphasis on religiously using only one language.
