# perdian does dotfiles

After having managed my personal configurations manually for as long as I can
think I got tired of setting up the correct configuration over and over again
when switching to a new computer and making sure all the machines that I use
(at home, in the office, my personal server, etc.) are all configured
similarly.

As with many projects I'm standing on the shoulers of giant and have reclessly
copied ideas and configurations from many sources, most prominently
[Zach Holman](https://github.com/holman/dotfiles) and [Ryan Bates](https://github.com/ryanb/dotfiles).

## Topics

The individual configuration files and resources have been grouped around
*topic areas*, where each topic area is represented by its own subdirectory
inside the main repository.

Anything with an extension of `.zsh` will get automatically included into your
shell. Anything with an extension of `.symlink` will get symlinked without
extension into `$HOME` when you run `bootstrap.py`.

## What's inside

My personal collection of configurations - mostly designed to work on OS X but
also on Linux flavors (like Ubuntu which powers my personal server). I'm not
suggesting it works for everybody but it definitely works for me. If you find it
interesting [fork it](https://github.com/perdian/dotfiles/fork), remove what you
don't use, and build on what you do use.

## Components

There are a few special files in the hierarchy.

- **bin/**: Anything in `bin/` will get added to your `$PATH` and be made
  available everywhere.
- **topic/\*.zsh**: Any files ending in `.zsh` get loaded into your environment.
- **topic/\*.symlink**: Any files ending in `.symlink` get symlinked into
  your `$HOME`. This enabled you to keep all of your files versioned in your
  dotfiles but still keep those autoloaded files in your home directory. These
  get symlinked in when you run `bootstrap.py`.

## Prerequesits

There are only a few prerequesites that you need to have in place to use the dotfiles:

- Python must be installed on the system you're running the `bootstrap.py`.

### Linux

On standard Linux distributions the `realpath` command is not available and
needs to be installed:

    sudo apt-get install realpath

## Installation

Checkout the repository to any location on your local system (e.g. `.dotfiles`
in your home directory) and call the bootstrap script to initialize the
configuration items;

    git clone https://github.com/perdian/dotfiles.git ~/.dotfiles
    cd ~/.dotfiles
    ./bootstrap.py

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
