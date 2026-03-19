#!/usr/bin/env bash

if [ -z "$HOME" ]; then
  echo "🚨 Seems you're \$HOMEless";
  exit 1;
fi

DOTFILES=$HOME/.dotfiles
COMMANDS="curl git stow"

for COMMAND in $COMMANDS; do
  if ! command -v "$COMMAND" &> /dev/null; then
    echo "🚨 Required command $COMMAND is not installed";
    exit 1;
  fi
done

if [ ! -d "$DOTFILES" ]; then
  git clone ssh://git@git.sherver.org:22381/joshtronic/dotfiles.git "$DOTFILES"
  cd "$DOTFILES" || exit
else
  cd "$DOTFILES" || exit
  # TODO: Commented out while I do things
  # git pull origin main
fi

# Out with the old
stow alacritty

if [[ `uname` == Darwin ]]; then
  stow macos
fi

symlink() {
  local SRC="$1"
  local DEST="$2"

  if [ -L "$DEST" ]; then
    rm "$DEST"
  elif [ -e "$DEST" ] || [ -d "$DEST" ]; then
    echo "🚨 $DEST already exists, remove it and try again"
    exit 1
  fi

  mkdir -p "$(dirname "$DEST")"
  ln -sf "$SRC" "$DEST"
  echo "🔗 $SRC => $DEST"
}

linkage() {
  local DIR="$1"

  if [ -n "$2" ]; then
    symlink "$DOTFILES/$DIR" "$2"
  else
    for FILE in "$DOTFILES/$DIR"/*; do
      symlink "$FILE" "$HOME/.$(basename "$FILE")"
    done
  fi
}

linkage "git"
linkage "tmux"
linkage "vim"
linkage "zsh"

mkdir -p ~/.local/share/vim/undo/

cd "$HOME" || exit
rm -f "${HOME}/.zcompdump*"

echo
echo "🎉 Done! Restart your shell."
