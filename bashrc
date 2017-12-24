#!/usr/bin/env bash

export DOTFILES=$HOME/.dotfiles

[ -f $DOTFILES/env ] && source $DOTFILES/env
[ -f $DOTFILES/aliases ] && source $DOTFILES/aliases
[ -x /usr/bin/dircolors ] && eval `dircolors $DOTFILES/dircolors`
[ -f ~/.fzf.bash ] && source ~/.fzf.bash

bind 'set show-all-if-ambiguous on'
bind 'TAB:menu-complete'

git_super_status() {
  echo ''
}

blue=$(tput setaf 4)
reset=$(tput sgr0)
grey=$(tput setaf 244)

PS1='
\[$blue\]\w $(git_super_status)
\[$grey\]\$ \[$reset\]'
