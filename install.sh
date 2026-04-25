#!/usr/bin/env bash

DOTFILES=$HOME/.dotfiles
GIT_SSH="ssh://git@git.sherver.org:22381"
GIT_HTTPS="https://git.sherver.org"
COMMANDS="curl fzf git"
ZSH_PLUGINS="$HOME/.zsh/plugins"
ZSH_PLUGIN_LIST=(
  zsh-autosuggestions
  zsh-history-substring-search
  zsh-syntax-highlighting
)

heading() { echo; echo "$1"; printf '%.0s-' {1..80}; echo; }
success() { echo "✅ $1"; }
warn() { echo "⚠️  $1"; }
error() { echo "❌ $1"; exit 1; }

heading "🚀 Installing joshtronic's juicy dotfiles"

if [ -z "$HOME" ]; then
  error "You're \$HOMEless"
fi

success "You're not \$HOMEless"

for COMMAND in $COMMANDS; do
  if ! command -v "$COMMAND" &> /dev/null; then
    error "$COMMAND is not installed"
  fi

  success "$COMMAND is installed"
done

if [ ! -d "$DOTFILES" ]; then
  if git clone "$GIT_HTTPS/joshtronic/dotfiles.git" "$DOTFILES" &> /dev/null; then
    success "Cloned dotfiles"
  else
    error "Failed to clone dotfiles"
  fi
  cd "$DOTFILES" || exit
  git remote set-url origin "$GIT_SSH/joshtronic/dotfiles.git"
else
  cd "$DOTFILES" || exit

  if [ -z "$(git status --porcelain)" ]; then
    LOCAL=$(git rev-parse HEAD)
    git pull "$GIT_HTTPS/joshtronic/dotfiles.git" main &> /dev/null
    REMOTE=$(git rev-parse HEAD)

    if [ "$LOCAL" != "$REMOTE" ]; then
      success "Pulled latest dotfiles changes"
    else
      success "No dotfiles changes to pull"
    fi
  else
    warn "Local dotfiles changes detected, skipping pull"
  fi
fi

if [ ! -f "$HOME/.gitconfig.local" ]; then
  heading "🛠️  Git"

  read -rp "Name: " GIT_NAME
  read -rp "Email: " GIT_EMAIL
  read -rp "GitHub username: " GIT_GITHUB_USER

  cat > "$HOME/.gitconfig.local" <<EOF
[user]
  name = $GIT_NAME
  email = $GIT_EMAIL

[github]
  user = $GIT_GITHUB_USER
EOF

  success "Created ~/.gitconfig.local"
else
  success "Found ~/.gitconfig.local"
fi

if command -v fc-list &> /dev/null; then
  if fc-list | grep -qi "Victor Mono"; then
    success "Victor Mono font is installed"
  else
    warn "Victor Mono font is not installed"
  fi
fi

symlink() {
  local SRC="$1"
  local DEST="$2"
  local SHORT_SRC="${SRC/$HOME/\~}"
  local SHORT_DEST="${DEST/$HOME/\~}"

  if [ -L "$DEST" ]; then
    rm "$DEST"
  elif [ -e "$DEST" ] || [ -d "$DEST" ]; then
    echo
    error "$SHORT_DEST already exists, remove it and try again"
  fi

  mkdir -p "$(dirname "$DEST")"
  ln -sf "$SRC" "$DEST"
  echo "🔗 $SHORT_SRC => $SHORT_DEST"
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
linkage "git"
symlink "$DOTFILES/tmux/tmux.conf" "$HOME/.tmux.conf"
linkage "vim"
symlink "$DOTFILES/zsh/zshrc" "$HOME/.zshrc"

curl -fsSL https://fnm.vercel.app/install 2>/dev/null \
  | bash -s -- --skip-shell &> /dev/null
echo "📦 Fast Node Manager"

if ! fnm ls 2>/dev/null | grep -q default; then
  fnm install --lts &> /dev/null
  fnm default lts-latest &> /dev/null
  success "Installed Node.js LTS as default"
fi

curl -fLo ~/.vim/autoload/plug.vim --create-dirs \
  "$GIT_HTTPS/mirrors/vim-plug/raw/branch/master/plug.vim" &> /dev/null
echo "🔌 vim-plug"

mkdir -p ~/.local/share/vim/undo/
mkdir -p "$ZSH_PLUGINS"

for PLUGIN in "${ZSH_PLUGIN_LIST[@]}"; do
  if [ -d "$ZSH_PLUGINS/$PLUGIN" ]; then
    git -C "$ZSH_PLUGINS/$PLUGIN" pull &> /dev/null
  else
    git clone "$GIT_HTTPS/mirrors/$PLUGIN" "$ZSH_PLUGINS/$PLUGIN" &> /dev/null
  fi
  echo "🔌 $PLUGIN"
done

cd "$HOME" || exit
rm -f "${HOME}/.zcompdump*"
zsh -c 'autoload -Uz compinit && compinit' &> /dev/null
success "Regenerated Zsh completions"

if [[ $(uname) == Darwin ]]; then
  heading "🍎 macOS"
  linkage "karabiner" "$HOME/.config/karabiner"
  echo "👉 ~/.hushlogin"
  touch "$HOME/.hushlogin"
fi

echo
echo "🎉 Done! Restart your shell."
