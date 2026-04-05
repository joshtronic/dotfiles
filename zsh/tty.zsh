TTY_NAME="$(tty | sed 's|/dev/||')"

if [[ "$TTY_NAME" =~ ^tty[0-9]+$ ]]; then
  # Rose Pine Moon palette for the Linux TTY
  printf '\e]P0232136' # background / black
  printf '\e]P1eb6f92' # red
  printf '\e]P23e8fb0' # green
  printf '\e]P3f6c177' # yellow
  printf '\e]P49ccfd8' # blue
  printf '\e]P5c4a7e7' # magenta
  printf '\e]P6ea9a97' # cyan
  printf '\e]P7e0def4' # foreground / white
  printf '\e]P86e6a86' # bright black
  printf '\e]P9eb6f92' # bright red
  printf '\e]PA3e8fb0' # bright green
  printf '\e]PBf6c177' # bright yellow
  printf '\e]PC9ccfd8' # bright blue
  printf '\e]PDc4a7e7' # bright magenta
  printf '\e]PEea9a97' # bright cyan
  printf '\e]PFe0def4' # bright white
  clear

  if [[ -z "$TMUX" ]]; then
    SESSION="${TTY_NAME:-tty}"

    if tmux has-session -t "$SESSION" 2>/dev/null; then
      exec tmux attach-session -t "$SESSION"
    else
      exec tmux new-session -s "$SESSION" "$DOTFILES/zsh/motd.sh"
    fi
  fi
fi
