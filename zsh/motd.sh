#!/usr/bin/env bash

if command -v cbonsai &> /dev/null && command -v fortune &> /dev/null; then
  cbonsai -m "$(fortune)" -p
fi

exec zsh
