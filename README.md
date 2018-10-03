# perdian does dotfiles

After having managed my personal configurations and install scripts manually for years I got tired of setting up the different settings over and over again when switching to a new computer, making  sure all the machines that I use (at home, in the office, my personal server, etc.) are all  configured similarly and have all the bits and pieces in place I expect from them.

This dotfiles project is the result (or let's call it work in progress) of me wanting to have all these tweaks versioned and easy to access at any time.

As with many projects I'm standing on the shoulders of great people and have recklessly copied ideas and configurations from many sources, most prominently [Zach Holman](https://github.com/holman/dotfiles) and [Ryan Bates](https://github.com/ryanb/dotfiles).

## What's inside

My personal collection of configurations mostly designed to work on macOS but also on Linux flavors (like Ubuntu which powers my personal webserver).
I'm far from suggesting that it works for everybody but it definitely works for me.
If you find it interesting [fork it](https://github.com/perdian/dotfiles/fork), remove what you don't use, and build on what you do use.
The project itself is not necessarily designed to be used as is by anyone else but should merely servce as an idea of how *your* personal dotfiles could be structured.

However: If you are lazy and just want to completely copy my personal stuff: Feel free to do so!

## Environments

I do not want *all* dotfiles to be available on *all* environments.
For example certain configurations only apply to my personal machine (that is running macOS) and not my server (that is running Ubuntu).

The concept of *environments* provides an abstraction for this where during the bootstrap process (when opening a new terminal) a series of discovery processes is started and only those environments discovered will be made available.

All environment specific scripts and settings are stored inside the `environments` subfolder.
Each subfolder within the `environments` subfolder represents a separate set of settings specific to that environment.
The environment itself is included during the bootstrap process depending on its *activation criteria*:

The `default` environment will be included automatically.
The `macos` and `linux` environments will also be included automatically if the startup process discovers that it's running on macOS or Linux.

All other environments must be selected manually by adding a line for each environment into a file named `.dotfiles-environment` located in the personal home directory.

Within the dotfiles project there are currently no manually selectable environment available as so far everything works fine for me with the automatic environments.

### Topics

The individual configuration files and resources inside the environments are grouped around *topic areas*, where each topic area is represented by its own subdirectory below the environment directory.

Anything with an extension of `.symlink`

### Components

There are a few special files inside the hierarchy.

- **environments/ENVIRONMENT_NAME/TOPIC/bin/\***: Anything in `bin/` will get added to your `$PATH` and will be made available everywhere.
- **environments/ENVIRONMENT_NAME/TOPIC/\*\*/\*.zsh**: Any files ending with `.zsh` will get loaded into the shell environment.
- **environments/ENVIRONMENT_NAME/TOPIC/\*\*/\*.symlink**: Any files ending in `.symlink` will get symlinked into a target directory inside the home directory (or the home directory itself). The part between an (optional) 'at' character and the `.symlink` extension will determine the exact target directory below the users home directory.  If no explicit target directory is given (the extension is just `.symlink`) then the link will be created inside the users home directory (`$HOME`). Otherwise the part between the 'at' character and the `.symlink` extension will be translated into a directory below the home directory, where all 'at' characters will be replaced by a forward slash.  So for example the file `private.xml@Library@Application Support@karabiner.symlink` will be translated to the actual target directory `~/Library/Application Support/karabiner`. This enables me to keep all of my files versioned in the dotfiles but still keep those autoloaded files in my home directory. The symlinks will be created when running the `install.py` script inside the `environments` folder.

### Coexistence with other local settings

There may be some settings that you want to have on a particular machine only and not checked into into the dotfiles project itself (at least I do).
But as the `.zshrc` symlink is created by the dotfiles installer I need another way to make additional local configuration available.
To support this setup, a special folder `.zshrc.local` can be created inside the users home directory.
This is handled as an additional environment (including topic folders) which will be included in the shell setup processing:

- **~/.zshrc.local/bin/\***: Anything in `bin/` will get added to your `$PATH` and will be made available everywhere.
- **~/.zshrc.local/\*\*/\*.zsh**: Any files ending with `.zsh` will get loaded into the shell environment.

### Installation

Checkout the repository to any location on your local system (e.g. `.dotfiles` in your home directory) and call the install script of the target platform:

This will symlink the appropriate files in `.dotfiles` to your home directory.
Everything will be configured and tweaked within `~/.dotfiles` (or wherever your choose to checkout the repository into).

The install script should only be executed once but will check whether the changes it wants to make are already active and will skip certain installation steps if necessary.

#### macOS

        $ git clone https://github.com/perdian/dotfiles.git ~/.dotfiles
        $ ~/.dotfiles/environments/install.py

The necessary dependencies will be installed automatically by the install script, making sure Homebrew is installed and downloading all additional resources through Homebrew.

#### Linux

Some necessary system tools might be missing, so to be on the safe side make sure to install the following system components before calling the install script:

        $ sudo apt-get install dialog git zsh python vim
        $ git clone https://github.com/perdian/dotfiles.git ~/.dotfiles
        $ ~/.dotfiles/environments/install.py
