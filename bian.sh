#!/usr/bin/env bash

DOTFILES=$HOME/.dotfiles

heading() { echo; echo "$1"; printf '%.0s-' {1..80}; echo; }
success() { echo "✅ $1"; }
warn() { echo "⚠️  $1"; }
error() { echo "❌ $1"; exit 1; }

heading "🤏 bian: Debian, without the DE"

if [[ $(uname) != Linux ]]; then
  error "bian is for Linux only"
fi

if ! command -v apt &> /dev/null; then
  error "bian is for Debian-based systems only"
fi

heading "📦 System packages"

PACKAGES=(
  curl
  fbterm
  fontconfig
  fzf
  git
  network-manager
  physlock
  tlp
  tlp-rdw
  unzip
  zsh
)

sudo apt update &> /dev/null
sudo apt install -y "${PACKAGES[@]}" &> /dev/null
success "Installed system packages"

heading "🐚 Shell"

if [[ "$SHELL" != *zsh ]]; then
  chsh -s "$(command -v zsh)"
  success "Changed login shell to zsh"
else
  success "Login shell is already zsh"
fi

heading "🔋 Power management"

sudo systemctl enable tlp &> /dev/null
sudo systemctl start tlp &> /dev/null
success "Enabled tlp"

heading "⌨️  Keyboard"

if ! grep -q "ctrl:nocaps" /etc/default/keyboard 2>/dev/null; then
  sudo sed -i 's/^XKBOPTIONS=.*/XKBOPTIONS="ctrl:nocaps"/' /etc/default/keyboard
  sudo setupcon &> /dev/null
  success "Mapped Caps Lock to Ctrl"
else
  success "Caps Lock already mapped to Ctrl"
fi

heading "🔤 Victor Mono font"

if ! fc-list 2>/dev/null | grep -qi "Victor Mono"; then
  mkdir -p "$HOME/.local/share/fonts"
  curl -fsSL -o /tmp/VictorMonoAll.zip \
    https://github.com/rubjo/victor-mono/raw/master/public/VictorMonoAll.zip &> /dev/null
  unzip -o /tmp/VictorMonoAll.zip 'OTF/*' -d "$HOME/.local/share/fonts" &> /dev/null
  rm /tmp/VictorMonoAll.zip
  fc-cache -f &> /dev/null
  success "Installed Victor Mono"
else
  success "Victor Mono already installed"
fi

heading "🎁 Handing off to install.sh"

bash "$DOTFILES/install.sh"

heading "🔗 bian overrides"

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

symlink "$DOTFILES/tmux/tty.conf" "$HOME/.tmux.conf"
symlink "$DOTFILES/fbterm/fbtermrc" "$HOME/.fbtermrc"
