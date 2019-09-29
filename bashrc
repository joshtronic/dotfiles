#!/usr/bin/env bash
# shellcheck disable=SC1090

export DOTFILES=$HOME/.dotfiles
export INCLUDES=$HOME/.local/share/dotfiles

source "$DOTFILES/env"
source "$DOTFILES/aliases"
source "$HOME/.fzf.bash"

source /usr/share/bash-completion/bash_completion

eval "$(dircolors "$DOTFILES/dircolors")"

bind 'set completion-ignore-case on'
bind 'set show-all-if-ambiguous on'
bind 'TAB:menu-complete'

RESET="$(tput sgr0)"

BLUE="$(tput setaf 4)"
GREEN="$(tput setaf 2)"
GREY="$(tput setaf 244)"
RED="$(tput setaf 1)"
YELLOW="$(tput setaf 3)"

git_prompt() {
  BRANCH=$(git branch 2> /dev/null | sed -e '/^[^*]/d' -e 's/*\(.*\)/\1/')

  if [ -n "$BRANCH" ]; then
    echo -n "$YELLOW$BRANCH"

    if [ -n "$(git status --short)" ]; then
      echo " ${RED}✗"
    fi
  fi
}

vim_prompt() {
  if [ -n "$VIMRUNTIME" ]; then
    echo ":${GREEN}sh ";
  fi
}

PS1="
\[$(vim_prompt)$BLUE\w$(git_prompt)\]
\[$GREY\]$ \[$RESET\]"
