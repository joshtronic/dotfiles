#!/usr/bin/env bash

DOTFILES=$HOME/.dotfiles
COMMANDS="curl git"
ZSH_PLUGINS="$HOME/.zsh/plugins"
ZSH_PLUGIN_LIST=(
  zsh-autosuggestions
  zsh-history-substring-search
  zsh-syntax-highlighting
)

heading() {
  echo
  echo "$1"
  printf '%.0s-' {1..80}
  echo
}

heading "🚀 Installing some juicy dotfiles"

echo "🏠 Making sure you have a \$HOME"

if [ -z "$HOME" ]; then
  echo
  echo "🚨 Seems you're \$HOMEless";
  exit 1;
fi

for COMMAND in $COMMANDS; do
  echo "📦 Making sure you have \`$COMMAND\` installed"

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

  if [ -z "$(git status --porcelain)" ]; then
    git pull origin main
  else
    echo "🙅 Local changes detected, skipping pull"
  fi
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

heading "🌎 Cross-platform"
linkage "alacritty" "$HOME/.config/alacritty"
linkage "fish" "$HOME/.config/fish"
linkage "git"
linkage "tmux"
linkage "vim"
symlink "zsh/zshrc" "$HOME/.zshrc"

if [[ $(uname) == Darwin ]]; then
  heading "🍎 macOS"
  linkage "karabiner" "$HOME/.config/karabiner"
  echo "👉 $HOME/.hushlogin"
  touch "$HOME/.hushlogin"
fi

if [ ! -f "$HOME/.theme" ]; then
  echo "🎨 $HOME/.theme"
  echo 'light' > "$HOME/.theme"
fi

heading "🔌 Zsh plugins"

mkdir -p "$ZSH_PLUGINS"

for PLUGIN in "${ZSH_PLUGIN_LIST[@]}"; do
  if [ -d "$ZSH_PLUGINS/$PLUGIN" ]; then
    echo "⬆️  Updating $PLUGIN"
    git -C "$ZSH_PLUGINS/$PLUGIN" pull
  else
    echo "📥 Cloning $PLUGIN"
    git clone "https://git.sherver.org/mirrors/$PLUGIN" "$ZSH_PLUGINS/$PLUGIN"
  fi
done

heading "📦 Fast Node Manager"
curl -fsSL https://fnm.vercel.app/install | bash -s -- --skip-shell

heading "🔌 vim-plug"
curl -fLo ~/.vim/autoload/plug.vim --create-dirs \
  https://git.sherver.org/mirrors/vim-plug/raw/branch/master/plug.vim

mkdir -p ~/.local/share/vim/undo/

cd "$HOME" || exit
rm -f "${HOME}/.zcompdump*"

echo
echo "🎉 Done! Restart your shell."
