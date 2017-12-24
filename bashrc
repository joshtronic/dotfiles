#!/usr/bin/env bash

export DOTFILES=$HOME/.dotfiles

if [ -x /usr/bin/dircolors ]; then
  eval `dircolors $DOTFILES/dircolors`
fi

source $DOTFILES/env
source $DOTFILES/aliases
