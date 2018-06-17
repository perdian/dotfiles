# perdian does dotfiles

After having managed my personal configurations manually for years I got tired  of setting
up the different settings over and over again when switching to a new computer, making sure
all the machines that I use (at home, in the office, my personal server, etc.) are all
configured similarly.

This dotfiles project is the result (or let's call it work in progress) of me wanting to
have all these tweaks versioned and easy to access at any time.

As with many projects I'm standing on the shoulders of great people and have reclessly
copied ideas and configurations from many sources, most prominently
[Zach Holman](https://github.com/holman/dotfiles) and [Ryan Bates](https://github.com/ryanb/dotfiles).

## What's inside

My personal collection of configurations - mostly designed to work on macOS but also on
Linux flavors (like Ubuntu which powers my personal webserver). I'm not suggesting it works
for everybody but it definitely works for me. If you find it interesting [fork it](https://github.com/perdian/dotfiles/fork),
remove what you don't use, and build on what you do use. The project itselt is not
necessarily designed to be used as is by anyone else but should merely servce as an idea of
how *your* personal dotfiles can be structured.

However: If you are lazy and just want to completely copy my personal stuff: Feel free to
do so!

## Environments

I do not want *all* dotfiles to be available on *all* environments. For example certain
configurations only apply to my personal machine (that is running macOS) and not my server
(that is running Ubuntu).

The concept of *environments* provides an abstraction for this where during the bootstrap
process a series of discovery processes is started and only those environments discovered
will be made available. Environments can be combined which means that a single installation
of the dotfiles can include multiple environments.

The `default` environment is special in that it will be included automatically by each and
every bootstrap process and does not have to be defined explicitely.

Apart from that there are two major other types of environments: `automatic` and `manual`.
All the environments located in the `automatic` directory will be selected automatically if
certain conditions are detected by the `bootstrap.py` script. For example the `macos`
environment is activated if the script detects that it is running on a macOS machine. All
the environments defined in the `manual` directory will have to be activated by adding them
to the `bootstrap.py` call on the command line:

    $ environments/bootstrap.py env1 env2 ...

### Special environments

The following environments are not initialized automatically and have to be added manually
via the `bootstrap.py` script:

#### root

Designed to be used on a Linux machine on which you are setting up the environment as root
user. It will install a series of additional packages via `apt-get`.

## Topics

The individual configuration files and resources inside the environments are grouped around
*topic areas*, where each topic area is represented by its own subdirectory below the
environment directory.

Anything with an extension of `.zsh` will get automatically included into your zsh shell.

Anything with an extension of `.symlink` will get symlinked into a target directory inside
the users home directory (or the home directory itself). The part between an (optional)
'at' character and the `.symlink` extension will determine the exact target directory below
the users home directory. If no explicit target directory is given (the extension is just
`.symlink`) then the link will be created inside the users home directory (`$HOME`).
Otherwise the part between the 'at' character and the `.symlink` extension will be
translated into the actual directory inside the home directory, where all 'at' characters
will be replaced by a forward slash. So for example the file `private.xml@Library@Application Support@karabiner.symlink`
will be translated to the actual target directory `~/Library/Application Support/karabiner`.

## Components

There are a few special files inside the hierarchy.

- **environments/\<environment>/topic/bin/**: Anything in `bin/` will get added to your
  `$PATH` and will be made available everywhere.
- **environments/\<environment>/topic/\*.zsh**: Any files ending with `.zsh` will get
  loaded into your environment.
- **environments/\<environment>/topic/\*.symlink**: Any files ending in `.symlink` will get
  symlinked into your `$HOME` directory - or a subdirectory (see above). This enables you
  to keep all of your files versioned in your dotfiles but still keep those autoloaded
  files in your home directory. The symlinks will be created when running the
  `bootstrap.py` script inside `environments`.

## Prerequesits

There are only a few prerequesites that you need to have in place to use the dotfiles:

### macOS

The necessary dependencies will be installed automatically by the `bootstrap.py` script
during the bootstrapping process by making sure Homebrew is installed and downloading all
additional resources through Homebrew.

### Linux

Some necessary system tools might be missing, so to be on the safe side make sure to install the following system components:

    sudo apt-get install dialog git zsh python nano

## Installation

Checkout the repository to any location on your local system (e.g. `.dotfiles` in your
home directory) and call the bootstrap script to initialize the configuration items:

    $ git clone https://github.com/perdian/dotfiles.git ~/.dotfiles
    $ ~/.dotfiles/environments/bootstrap.py

This will symlink the appropriate files in `.dotfiles` to your home directory. Everything
is configured and tweaked within `~/.dotfiles` (or wherever your choose to checkout the
repository into).

If will also initialize all the *bootstrap installers* in the dotfiles directory.

A bootstrap installer is considered any file within your dotfiles directory that matches
the name pattern `bootstrap-installer.*`. You should use a bootstrap installer to make sure
the topic is correctly initialized and has all system dependencies fulfilled.

The `bootstrap.py` as well as all the bootstrap installers should be considered idempotent
which means they can be executed multiple times and will only add additional configurations
to the system if they have not been applied yet.

## Coexistence with other local settings

There may be some settings that you want to have on a particular machine only and not
checked into into the dotfiles project itself (at least I do). But as the `.zshrc` symlink
is created by the dotfiles installer we need another way to make additional local
configuration available. To support this setup, a special folder `.zshrc.local` can be
created inside the users home directory. As with the topic folders, this folder will be
included in the shell setup processing:

- **~/.zshrc.local/**/bin/**: Anything in `bin/` will get added to your `$PATH` and will
  be made available everywhere.
- **~/.zshrc.local/**/*.zsh: Any files ending with `.zsh` will get loaded into your
  environment.
