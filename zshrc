#!/usr/bin/env zsh

DOTFILES=$HOME/.dotfiles
ADOTDIR=$DOTFILES/vendor/zsh-users/antigen/
GREP_EXCLUDE_DIR="{.git,.sass-cache,artwork,node_modules,vendor}"
OS=`uname`

export CLICOLOR=1
export EDITOR=vim
export KEYTIMEOUT=1
export TERM="xterm-256color"

bindkey -v

if [ $OS = 'Linux' ]; then
    alias pbcopy='xclip -selection clipboard'
    alias pbpaste='xclip -selection clipboard -o'

    if [ -x /usr/bin/dircolors ]; then
      test -r $HOME/.dircolors && eval "$(dircolors -b $HOME/.dircolors)" || eval "$(dircolors -b)"
      alias ls="ls --color=auto"

      GREP_FLAGS=" --color=auto --exclude-dir=${GREP_EXCLUDE_DIR}"

      alias grep="grep ${GREP_FLAGS}"
      alias egrep="egrep ${GREP_FLAGS}"
      alias fgrep="fgrep ${GREP_FLAGS}"
    fi
elif [ $OS = 'Darwin' ]; then
    export GREP_OPTIONS="--color=auto --exclude-dir=${GREP_EXCLUDE_DIR} --exclude-dir=.sass-cache"

    source "`brew --prefix`/etc/grc.bashrc"
    source $HOME/.rvm/scripts/rvm

    # Requires sudo, saves a step
    alias mtr="sudo mtr"

    # Because macOS is dumb
    alias mux="tmuxinator"

    # Unquarantine files on OSX
    alias unquarantine="xattr -r -d com.apple.quarantine *"

    # Because OS X returns all caps
    function uuidgen() { env uuidgen "$@" | awk '{print tolower($0)}'; }
fi

source $DOTFILES/vendor/zsh-users/antigen/antigen.zsh
antigen-use oh-my-zsh
antigen-bundle zsh-users/zsh-autosuggestions
antigen-bundle zsh-users/zsh-completions
antigen-bundle zsh-users/zsh-syntax-highlighting
antigen-bundle zsh-users/zsh-history-substring-search
antigen-apply

bindkey '^[[A' history-substring-search-up
bindkey '^[[B' history-substring-search-down

# Safety first
alias cp="cp -i"
alias mv="mv -i"
alias rm="rm -i"

# Git aliases
alias g='git'
alias ga='git add'
alias gaa='git add --all'
alias gc='git commit -v'
alias gca='git commit -a -v'
alias gcb='git checkout -b'
alias gcm='git checkout master'
alias gco='git checkout'
alias gd='git diff'
alias gf='git fetch origin $(git_current_branch)'
alias gl='git pull origin $(git_current_branch)'
alias glg='git log'
alias gm='git merge'
alias gmm='git merge master'
alias gmv='git mv'
alias gp='git push origin $(git_current_branch)'
alias grm='git rm'
alias gst='git status'

# HTTPie aliases
alias GET='http'
alias POST='http POST'
alias HEAD='http HEAD'
alias dl='http --print=b --download'

# Ship
alias ship="$DOTFILES/vendor/fetchlogic/ship/ship"

# Tmuxinator
alias m='mux start'

# UUID
alias uuid='uuidgen'

# Vim aliases
alias v='env vim'
alias vd='env vimdiff'

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
    echo %{$FG[248]%}%n
  fi
}

function server() {
  if [[ `hostname` != josh-* ]]; then
    echo "%{$FG[244]%}@%{$fg[magenta]%}%m "
  fi
}

PROMPT_USER="$(username)$(server)"
PROMPT='
%{$PROMPT_USER%}%{$fg[blue]%}%~ $(git_prompt_info)
%{$FG[244]%}%# %{$reset_color%}'

ZSH_THEME_GIT_PROMPT_PREFIX="%{$fg[yellow]%}"
ZSH_THEME_GIT_PROMPT_SUFFIX="%{$reset_color%}"
ZSH_THEME_GIT_PROMPT_DIRTY=" %{$fg[red]%}✗"
ZSH_THEME_GIT_PROMPT_CLEAN=""

