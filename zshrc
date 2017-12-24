#!/usr/bin/env zsh

export DOTFILES=$HOME/.dotfiles

[ -f $DOTFILES/env ] && source $DOTFILES/env
[ -f $DOTFILES/aliases ] && source $DOTFILES/aliases
[ -x /usr/bin/dircolors ] && eval `dircolors $DOTFILES/dircolors`
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

fpath=($DOTFILES/vendor/zsh-users/zsh-completions/src $fpath)

HISTFILE=$HOME/.zsh_history
HISTSIZE=10000
SAVEHIST=10000

zstyle ':completion:*' menu select
zstyle ':completion:*' completer _complete
zstyle ':completion:*' matcher-list '' 'm:{[:lower:][:upper:]}={[:upper:][:lower:]}' '+l:|=* r:|=*'

autoload -U compinit && compinit
zmodload -i zsh/complist

unsetopt menu_complete
unsetopt flowcontrol

setopt always_to_end
setopt append_history
setopt auto_menu
setopt complete_in_word
setopt extended_history
setopt hist_expire_dups_first
setopt hist_ignore_dups
setopt hist_ignore_space
setopt hist_verify
setopt inc_append_history
setopt interactivecomments
setopt share_history

bindkey -v

bindkey '^a' beginning-of-line
bindkey '^e' end-of-line

git_branch() {
  (command git symbolic-ref -q HEAD || command git name-rev --name-only --no-undefined --always HEAD) 2>/dev/null
}

# `ls` after `cd`
function cd {
  builtin cd "$@" && ls -F
}

function username() {
  if [[ `whoami` != 'josh' ]]; then
    echo "%F{248}%n%F{reset}"
  fi
}

function server() {
  if [[ `hostname` != josh-* ]]; then
    echo "%F{244}@%F{magenta}%m%F{reset} "
  fi
}

source $DOTFILES/vendor/olivierverdier/zsh-git-prompt/zshrc.sh

ZSH_THEME_GIT_PROMPT_PREFIX=""
ZSH_THEME_GIT_PROMPT_SUFFIX="%F{reset}"
ZSH_THEME_GIT_PROMPT_SEPARATOR=" "
ZSH_THEME_GIT_PROMPT_BRANCH="%F{yellow}"
ZSH_THEME_GIT_PROMPT_CLEAN=""
ZSH_THEME_GIT_PROMPT_DIRTY="%F{red}✗"

git_super_status() {
  precmd_update_git_vars

  if [ -n "$__CURRENT_GIT_STATUS" ]; then
    STATUS="$ZSH_THEME_GIT_PROMPT_PREFIX$ZSH_THEME_GIT_PROMPT_BRANCH$GIT_BRANCH$ZSH_THEME_GIT_PROMPT_SEPARATOR"

    if [ "$GIT_CHANGED" -eq "0" ] && [ "$GIT_CONFLICTS" -eq "0" ] && [ "$GIT_STAGED" -eq "0" ] && [ "$GIT_UNTRACKED" -eq "0" ]; then
      STATUS="$STATUS$ZSH_THEME_GIT_PROMPT_CLEAN"
    else
      STATUS="$STATUS$ZSH_THEME_GIT_PROMPT_DIRTY"
    fi

    STATUS="$STATUS%{${reset_color}%}$ZSH_THEME_GIT_PROMPT_SUFFIX"
    echo "$STATUS"
  fi
}

PROMPT_USER="$(username)$(server)"
PROMPT='
%F{reset}$PROMPT_USER%F{blue}%~ $(git_super_status)
%F{244}%# %F{reset}'

source $DOTFILES/vendor/zsh-users/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
source $DOTFILES/vendor/zsh-users/zsh-history-substring-search/zsh-history-substring-search.zsh
