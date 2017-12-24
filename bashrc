#!/usr/bin/env bash

if [ -f $HOME/.env ]; then
  source $HOME/.env
fi

if [ -f $HOME/.aliases ]; then
  source $HOME/.aliases
fi
