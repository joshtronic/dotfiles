#!/usr/bin/env fish

# Disable the welcome message
set fish_greeting

# Setup some basic environment variables
set -gx EDITOR vim
set -gx QUOTING_STYLE literal

# Start configuring our path
fish_add_path $HOME/.local/bin

if test (uname) = Darwin
  fish_add_path /opt/homebrew/bin
  fish_add_path /opt/homebrew/opt/fnm/bin

  # Speed up `brew install`
  set -gx HOMEBREW_NO_AUTO_UPDATE 1
  set -gx HOMEBREW_NO_INSTALL_CLEANUP 1

  alias ls 'gls --color=auto --human-readable --classify'

  # Force uuidgen to use lowercase letters like Linux
  alias uuidgen 'uuidgen | tr A-F a-f'
else
  fish_add_path $HOME/.local/share/fnm

  set -gx SSH_AUTH_SOCK $XDG_RUNTIME_DIR/gcr/ssh

  alias bat 'batcat'
  alias ls 'ls --color=auto --human-readable --classify'

  # Use the same open command as macOS
  alias open 'xdg-open'
end

# Wire up fnm if it's available
if type -q fnm
  fnm env --shell fish --use-on-cd --version-file-strategy recursive | source
end
