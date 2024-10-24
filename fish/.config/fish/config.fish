#!/usr/bin/env fish

# Speed up `brew install`
set -gx HOMEBREW_NO_AUTO_UPDATE 1
set -gx HOMEBREW_NO_INSTALL_CLEANUP 1

source $HOME/.env
source $HOME/.aliases

eval (dircolors $HOME/.dircolors)

# Load up and configure fzf, nvm, and zsh plugins
if test (uname) = "Darwin"
  # macOs

elif type -q apt
  # Debian

elif type -q pacman
  # Arch

end
