#!/usr/bin/env bash

export DOTFILES=$HOME/.dotfiles
export INCLUDES=$HOME/.local/share/dotfiles

RESET=$(tput sgr0)

BLUE=$(tput setaf 4)
GREY=$(tput setaf 244)
RED=$(tput setaf 1)
YELLOW=$(tput setaf 3)

GIT_PROMPT_BRANCH='$YELLOW'
GIT_PROMPT_PREFIX=''
GIT_PROMPT_SUFFIX=''
GIT_PROMPT_CLEAN=''

GIT_PROMPT_START_USER='\n$BLUE\w'

GIT_PROMPT_END_USER='\n$GREY$ $RESET'
GIT_PROMPT_END_ROOT='\n$GREY# $RESET'

source $INCLUDES/bash-git-prompt/gitprompt.sh

source $DOTFILES/env
source $DOTFILES/aliases
source $HOME/.fzf.bash

source /usr/share/bash-completion/bash_completion

eval `dircolors $DOTFILES/dircolors`

bind 'set completion-ignore-case on'
bind 'set show-all-if-ambiguous on'
bind 'TAB:menu-complete'

PS1='\n$BLUE\w\n$GREY$ $RESET'
