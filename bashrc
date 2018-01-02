#!/usr/bin/env bash

export DOTFILES=$HOME/.dotfiles
export INCLUDES=$HOME/.local/share/dotfiles

source $DOTFILES/env
source $DOTFILES/aliases
source $HOME/.fzf.bash

eval `dircolors $DOTFILES/dircolors`

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
# source $INCLUDES/bash-git-prompt/gitprompt.sh
