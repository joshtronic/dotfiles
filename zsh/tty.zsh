TTY_NAME="$(tty | sed 's|/dev/||')"

if [[ "$TTY_NAME" =~ ^tty[0-9]+$ ]]; then
  if [[ "$TERM" == fbterm ]]; then
    # Rose Pine Moon palette for fbterm
    printf '\e[3;0;35;33;54}'      # black / background
    printf '\e[3;1;235;111;146}'   # red
    printf '\e[3;2;62;143;176}'    # green
    printf '\e[3;3;246;193;119}'   # yellow
    printf '\e[3;4;156;207;216}'   # blue
    printf '\e[3;5;196;167;231}'   # magenta
    printf '\e[3;6;234;154;151}'   # cyan
    printf '\e[3;7;224;222;244}'   # white / foreground
    printf '\e[3;8;110;106;134}'   # bright black
    printf '\e[3;9;235;111;146}'   # bright red
    printf '\e[3;10;62;143;176}'   # bright green
    printf '\e[3;11;246;193;119}'  # bright yellow
    printf '\e[3;12;156;207;216}'  # bright blue
    printf '\e[3;13;196;167;231}'  # bright magenta
    printf '\e[3;14;234;154;151}'  # bright cyan
    printf '\e[3;15;224;222;244}'  # bright white
  else
    # Rose Pine Moon palette for the bare Linux TTY
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
  fi
  clear

  # if [[ -z "$TMUX" ]]; then
  #   SESSION="${TTY_NAME:-tty}"
  #
  #   if tmux has-session -t "$SESSION" 2>/dev/null; then
  #     exec tmux attach-session -t "$SESSION"
  #   else
  #     exec tmux new-session -s "$SESSION" "$DOTFILES/zsh/motd.sh"
  #   fi
  # fi
fi
