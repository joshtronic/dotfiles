#!/usr/bin/env bash

heading() {
  echo $1
  printf '%.0s-' {1..80}
  echo
}

echo "🚀 Installing some juicy dotfiles..."

if [ -z "$HOME" ]; then
  echo
  echo "🚨 Seems you're \$HOMEless";
  exit 1;
fi

DOTFILES=$HOME/.dotfiles
COMMANDS="curl git"

for COMMAND in $COMMANDS; do
  if ! command -v "$COMMAND" &> /dev/null; then
    echo
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

symlink() {
  local SRC="$1"
  local DEST="$2"

  if [ -L "$DEST" ]; then
    rm "$DEST"
  elif [ -e "$DEST" ] || [ -d "$DEST" ]; then
    echo
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

echo
heading "🌎 Cross-platform"
linkage "alacritty" "$HOME/.config/alacritty"
linkage "git"
linkage "tmux"
linkage "vim"
linkage "zsh"

if [[ `uname` == Darwin ]]; then
  echo
  heading "🍎 macOS"
  linkage "karabiner" "$HOME/.config/karabiner"
  echo "👉 $HOME/.hushlogin"
  touch "$HOME/.hushlogin"
fi

mkdir -p ~/.local/share/vim/undo/

cd "$HOME" || exit
rm -f "${HOME}/.zcompdump*"

echo
echo "🎉 Done! Restart your shell."
