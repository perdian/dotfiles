# perdian does dotfiles

After having managed my personal configurations manually for as long as I can
think I got tired of setting up the correct configuration over and over again
when switching to a new computer and making sure all the machines that I use
(at home, in the office, my personal server, etc.) are all configured
similarly.

As with many projects I'm standing on the shoulders of great people and have
reclessly copied ideas and configurations from many sources, most prominently
[Zach Holman](https://github.com/holman/dotfiles) and [Ryan Bates](https://github.com/ryanb/dotfiles).

## Environments

I do not want all dotfiles to be available on all environments. For example
certain configurations only apply to my personal machine (that is running OS X)
and not my server (that is running Ubuntu).

The concept of *environments* provides an abstraction for this where during the
bootstrap a series of discovery processes is started and only the environments
discovered will be made available. Environments can be combined which means that
a single installation of the dotfiles can include multiple environments.

The `default` environment is special in that it will be included into each and
every bootstrap process and does not have to be defined explicitely.

Apart from that there are two major other types of environments: `automatic`
and `manual`. All the environments defined in the `automatic` directory will
be selected automatically if certain conditions are detected by the
`bootstrap.py` script. For example the `osx` environment is activated if the
script detects that it is running on a OS X machine. All the environments
defined in the `manual` directory will have to be activated by adding them to
the `bootstrap.py` call on the command line:

    $ environments/bootstrap.py env1 env2 ...

## Topics

The individual configuration files and resources inside the environments are
grouped around *topic areas*, where each topic area is represented by its own
subdirectory inside the environment directory.

Anything with an extension of `.zsh` will get automatically included into your
zsh shell. Anything an extension of `.symlink` will get symlinked into a target
directory inside the home directory (or the home directory itself). The part
between an 'at' character and the `.symlink` extension will determine the exact
target directory inside the home directory. If no explicit target directory is
given (the extension is just `.symlink`) then the link will be created inside
the users home directory (`$HOME`). Otherwise the part between he 'at' character
and the `.symlink` extension will be translated into the actual directory inside
the home directory, where all at characters will replaced by a forward slash.
So for example the file `private.xml@Application Support@karabiner.symlink` will
be translated to the actual target directory `~/Library/Application Support/karabiner`.

## What's inside

My personal collection of configurations - mostly designed to work on OS X but
also on Linux flavors (like Ubuntu which powers my personal server). I'm not
suggesting it works for everybody but it definitely works for me. If you find it
interesting [fork it](https://github.com/perdian/dotfiles/fork), remove what you
don't use, and build on what you do use.

## Components

There are a few special files inside the hierarchy.

- **environments/auto/bin/**: Anything in `bin/` will get added to your `$PATH`
  and will be made available everywhere.
- **environments/\<environment>/topic/\*.zsh**: Any files ending in `.zsh` get
  loaded into your environment.
- **environments/\<environment>/topic/\*.symlink**: Any files ending in
  `.symlink` will get symlinked into your `$HOME` directory - or a subdirectory
  (see above). This enables you to keep all of your files versioned in your
  dotfiles but still keep those autoloaded files in your home directory. The
  symlinks will be created when running the `bootstrap.py` script inside
  `environments`.

## Prerequesits

There are only a few prerequesites that you need to have in place to use the
dotfiles:

### OS X

The necessary dependencies will be installed automatically by the `bootstrap.py`
script during the bootstrapping process by making sure Homebrew is installed and
requesting all necessary resources through Homebrew.

### Linux

On standard Linux distributions the `realpath` command is not available and
needs to be installed. Other necessary system tools might also be missing to to
be on the safe side install the following system components:

    sudo apt-get install realpath git zsh python

## Installation

Checkout the repository to any location on your local system (e.g. `.dotfiles`
in your home directory) and call the bootstrap script to initialize the
configuration items;

    git clone https://github.com/perdian/dotfiles.git ~/.dotfiles
    cd ~/.dotfiles
    ./environments/bootstrap.py

This will symlink the appropriate files in `.dotfiles` to your home directory.
Everything is configured and tweaked within `~/.dotfiles` (or wherever your
choose to checkout the repository).

If will also initialize all the *bootstrap installers* in your dotfiles.
A bootrap installer is considered any files within your dotfiles directory that
matches the name pattern `bootstrap-installer.*`. You should use that bootstrap
installer to make sure the topic is correctly initialized and has all system
dependencies fulfilled.

The `bootstrap.py` as well as all the bootstrap installers should be considered
idempotent which means they can be executed multiple times and will only add
additional configurations to the system if they have not been applied yet.
