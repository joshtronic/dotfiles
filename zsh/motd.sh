#!/usr/bin/env bash

if command -v toilet &> /dev/null; then
  toilet -f letter -F metal 'welcome'
fi

if command -v fortune &> /dev/null; then
  echo
  fortune
fi

echo
exec zsh
