#!/usr/bin/env zsh

DOTFILES=$HOME/.dotfiles
GREP_EXCLUDE_DIR="{.git,.sass-cache,artwork,node_modules,vendor}"
OS=`uname`
fpath=($DOTFILES/vendor/zsh-users/zsh-completions/src $fpath)

unalias -m "*"

export CLICOLOR=1
export EDITOR=vim
export KEYTIMEOUT=1
export TERM="xterm-256color"

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
bindkey '^h' backward-delete-char
bindkey '^j' up-history
bindkey '^k' down-history
bindkey '^r' history-incremental-search-backward
bindkey '^w' backward-kill-word

if [ $OS = 'Linux' ]; then
    alias pbcopy='xclip -selection clipboard'
    alias pbpaste='xclip -selection clipboard -o'

    if [ -x /usr/bin/dircolors ]; then
      eval `dircolors $DOTFILES/vendor/seebi/dircolors-solarized/dircolors.ansi-dark`
      alias ls='ls --color=auto'

      GREP_FLAGS=" --color=auto --exclude-dir=${GREP_EXCLUDE_DIR}"

      alias grep="grep ${GREP_FLAGS}"
      alias egrep="egrep ${GREP_FLAGS}"
      alias fgrep="fgrep ${GREP_FLAGS}"
    fi

    alias open='xdg-open'
elif [ $OS = 'Darwin' ]; then
    export GREP_OPTIONS="--color=auto --exclude-dir=${GREP_EXCLUDE_DIR} --exclude-dir=.sass-cache"

    source "`brew --prefix`/etc/grc.bashrc"
    source $HOME/.rvm/scripts/rvm

    # Requires sudo, saves a step
    alias mtr='sudo mtr'

    # Unquarantine files on OSX
    alias unquarantine='xattr -r -d com.apple.quarantine *'
    alias uq='unquarantine'

    # Because OS X returns all caps
    function uuidgen() { env uuidgen "$@" | awk '{print tolower($0)}'; }
fi

git_branch() {
  (command git symbolic-ref -q HEAD || command git name-rev --name-only --no-undefined --always HEAD) 2>/dev/null
}

# Safety first
alias cp='cp -i'
alias mv='mv -i'
alias rm='rm -i'

# Change Directory aliases
alias -- -='cd -'
alias ..='cd ..'
alias ....='cd ../..'
alias ......='cd ../../..'

# Docker aliases
alias dcs='docker-compose start'

# Git aliases
alias g='git'
alias ga='git add'
alias gaa='git add --all'
alias gb='git branch'
alias gc='git commit -v'
alias gca='git commit -a -v'
alias gcb='git checkout -b'
alias gcm='git checkout master'
alias gco='git checkout'
alias gd='git diff'
alias gf='git fetch'
alias gl='git pull origin $(git_branch)'
alias glg='git log'
alias gm='git merge'
alias gmm='git merge master'
alias gmv='git mv'
alias gp='git push origin $(git_branch)'
alias grm='git rm'
alias gst='git status'

# HTTPie aliases
alias GET='http'
alias POST='http POST'
alias HEAD='http HEAD'
alias dl='http --print=b --download'

# Open
alias o='open'

# Ship
alias ship="$DOTFILES/vendor/fetchlogic/ship/ship"

# Sudo
alias _='sudo'

# Tmuxinator
alias mux='tmuxinator'
alias m='mux start'

# UUID
alias uuid='uuidgen'

# Vim aliases
alias v='env vim'
alias vd='env vimdiff'
alias vp='env vim -p'

vim() { echo 'Wasted 2 keystrokes. Use `v` instead.' }
vimdiff() { echo 'Wasted 5 keystrokes. Use `vd` instead.' }

# Because `npm` shit the bed on me...
ulimit -n 4096

# `ls` after `cd`
function cd {
  builtin cd "$@" && ls -F
}

# Colorful man pages
man() {
  env \
    LESS_TERMCAP_md=$'\e[1;36m' \
    LESS_TERMCAP_me=$'\e[0m' \
    LESS_TERMCAP_se=$'\e[0m' \
    LESS_TERMCAP_so=$'\e[1;40;92m' \
    LESS_TERMCAP_ue=$'\e[0m' \
    LESS_TERMCAP_us=$'\e[1;32m' \
    man "$@"
}

ssh() {
  if [ "$(ps -p $(ps -p $$ -o ppid=) -o comm=)" = "tmux" ]; then
    tmux rename-window "$*"
    command ssh "$@"
    tmux set-window-option automatic-rename "on" 1>/dev/null
  else
    command ssh "$@"
  fi
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

bindkey '^[[A' history-substring-search-up
bindkey '^[[B' history-substring-search-down
bindkey '\eOA' history-substring-search-up
bindkey '\eOB' history-substring-search-down
bindkey -M vicmd 'k' history-substring-search-up
bindkey -M vicmd 'j' history-substring-search-down

