#!/usr/bin/env bash

# TODO: Check for ~/.gitconfig.local - If missing, prompt for the
# relevant bits of information and create it
# TODO: Move vim "installation" stuff to this script rather than
# inlined in the vimrc

if [ -z "$HOME" ]; then
  echo "Seems you're \$HOMEless :("; exit 1;
fi

DOTFILES=$HOME/.dotfiles
COMMANDS="curl git stow"

for COMMAND in $COMMANDS; do
  if ! command -v "$COMMAND" &> /dev/null; then
    echo "Please install $COMMAND";
    exit 1;
  fi
done

if [ ! -d "$DOTFILES" ]; then
  git clone ssh://git@git.sherver.org:22381/joshtronic/dotfiles.git "$DOTFILES"
  cd "$DOTFILES" || exit
else
  cd "$DOTFILES" || exit
  git pull origin main
fi

stow alacritty git tmux vim zsh

if [[ `uname` == Darwin ]]; then
  stow macos
fi

mkdir -p ~/.local/share/vim/undo/

cd "$HOME" || exit
rm -f "${HOME}/.zcompdump*"

echo
echo "ENJOY! :)"
