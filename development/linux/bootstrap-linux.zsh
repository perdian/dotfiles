#!/bin/zsh

echo "Building Docker container"
docker build -t dotfiles ${0:A:h}

echo "\nRunning Docker container"
docker run -it --rm \
  -v $(realpath ${0:A:h}/../../):/dotfiles \
  -e DOTFILES_HOME=/dotfiles \
  dotfiles zsh -lc '/dotfiles/install; exec zsh'
