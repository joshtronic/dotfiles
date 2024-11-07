#!/usr/bin/env bash

if [ -z "$HOME" ]; then
  echo "Seems you're \$HOMEless :("; exit 1;
fi

COMMANDS="curl git stow"

for COMMAND in $COMMANDS; do
  if ! command -v "$COMMAND" &> /dev/null; then
    echo "Please install $COMMAND";
    exit 1;
  fi
done

DOTFILES=$HOME/.dotfiles

if [ ! -d "$DOTFILES" ]; then
  git clone git@github.com:joshtronic/dotfiles.git "$DOTFILES"
  cd "$DOTFILES" || exit
else
  cd "$DOTFILES" || exit
  git pull origin main
fi

stow alacritty git nvim screen vim zsh

if [[ `uname` == Darwin ]]; then
  stow macos
else
  gsettings set org.gnome.mutter overlay-key ''
fi

mkdir -p ~/.local/share/vim/undo/

cd "$HOME" || exit
rm -f "${HOME}/.zcompdump*"

echo
echo "ENJOY! :)"
