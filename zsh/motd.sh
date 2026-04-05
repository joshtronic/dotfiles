#!/usr/bin/env bash

if command -v toilet &> /dev/null; then
  toilet -tf ascii12 --filter metal "WELCOME"
fi

if command -v fortune &> /dev/null; then
  fortune
fi

exec zsh
