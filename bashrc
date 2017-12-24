#!/usr/bin/env bash

export DOTFILES=$HOME/.dotfiles

source $DOTFILES/env
source $DOTFILES/aliases

if [ -x /usr/bin/dircolors ]; then
  eval `dircolors $DOTFILES/dircolors`
fi
