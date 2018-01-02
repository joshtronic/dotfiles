#!/usr/bin/env bash

export DOTFILES=$HOME/.dotfiles

[ -f $DOTFILES/env ] && source $DOTFILES/env
[ -f $DOTFILES/aliases ] && source $DOTFILES/aliases
[ -x /usr/bin/dircolors ] && eval `dircolors $DOTFILES/dircolors`
[ -f $HOME/.fzf.bash ] && source $HOME/.fzf.bash

bind 'set completion-ignore-case on'
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

# GIT_PROMPT_ONLY_IN_REPO=1
# GIT_PROMPT_THEME=Solarized
# source $HOME/.bash/bash-git-prompt/gitprompt.sh
