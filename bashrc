#!/usr/bin/env bash

export DOTFILES=$HOME/.dotfiles

[ -f $DOTFILES/env ] && source $DOTFILES/env
[ -f $DOTFILES/aliases ] && source $DOTFILES/aliases
[ -x /usr/bin/dircolors ] && eval `dircolors $DOTFILES/dircolors`
[ -f ~/.fzf.bash ] && source ~/.fzf.bash

bind 'set show-all-if-ambiguous on'
bind 'TAB:menu-complete'
