#!/usr/bin/env zsh

# Speed up `brew install`
export HOMEBREW_NO_AUTO_UPDATE=1
export HOMEBREW_NO_INSTALL_CLEANUP=1

# export GPG_TTY=$(tty)

source $HOME/.env
source $HOME/.aliases

eval `dircolors $HOME/.dircolors`

# TODO: Could set the base directory and source the zsh stuff
if [[ `uname` == Darwin ]]; then
  # macOS
  # Run this to generate ~/.fzf.zsh: $(brew --prefix)/opt/fzf/install
  [ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

  source /opt/homebrew/share/zsh-history-substring-search/zsh-history-substring-search.zsh
  source /opt/homebrew/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
elif command -v apt &> /dev/null; then
  # Debian
  source /usr/share/doc/fzf/examples/completion.zsh
  source /usr/share/doc/fzf/examples/key-bindings.zsh

  source /usr/share/zsh-history-substring-search/zsh-history-substring-search.zsh
  source /usr/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
elif command -v pacman &> /dev/null; then
  # Arch
  source /usr/share/fzf/completion.zsh
  source /usr/share/fzf/key-bindings.zsh

  source /usr/share/zsh/plugins/zsh-history-substring-search/zsh-history-substring-search.zsh
  source /usr/share/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
fi

# If you receive "highlighters directory not found" error message,                              │
# you may need to add the following to your .zshenv:                                            │
#   export ZSH_HIGHLIGHT_HIGHLIGHTERS_DIR=/opt/homebrew/share/zsh-syntax-highlighting/highlighte│
# rs

HISTFILE=$HOME/.zsh_history
HISTSIZE=1000000
SAVEHIST=1000000

zstyle ':completion:*' menu select
zstyle ':completion:*' completer _complete
zstyle ':completion:*' matcher-list '' 'm:{[:lower:][:upper:]}={[:upper:][:lower:]}' '+l:|=* r:|=*'

autoload -U compinit && compinit
zmodload -i zsh/complist

unsetopt menu_complete
unsetopt flowcontrol

setopt prompt_subst
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

git_prompt() {
  BRANCH=$(git branch 2> /dev/null | sed -e '/^[^*]/d' -e 's/*\(.*\)/\1/')

  if [ ! -z $BRANCH ]; then
    echo -n "%F{yellow}$BRANCH"

    STATUS=$(git status --short 2> /dev/null)

    if [ ! -z "$STATUS" ]; then
      echo " %F{red}✗"
    fi
  fi
}

PS1='
%F{blue}%~$(git_prompt)
%F{244}%# %F{reset}'

if [[ `uname` == Darwin ]]; then
  # macOS
  export NVM_DIR="$HOME/.nvm"
  [ -s "/opt/homebrew/opt/nvm/nvm.sh" ] && \. "/opt/homebrew/opt/nvm/nvm.sh"
elif command -v apt &> /dev/null; then
  # Debian
  export NVM_DIR="$HOME/.nvm"
  [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
  [ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"
elif command -v pacman &> /dev/null; then
  # Arch
  export NVM_DIR="$([ -z "${XDG_CONFIG_HOME-}" ] \
    && printf %s "${HOME}/.nvm" || printf %s "${XDG_CONFIG_HOME}/nvm")"
  [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
fi

# Automatically use Node.js version specified in .nvmrc
autoload -U add-zsh-hook

load-nvmrc() {
  local nvmrc_path="$(nvm_find_nvmrc)"

  if [ -n "$nvmrc_path" ]; then
    local nvmrc_node_version=$(nvm version "$(cat "${nvmrc_path}")")

    if [ "$nvmrc_node_version" = "N/A" ]; then
      nvm install
    elif [ "$nvmrc_node_version" != "$(nvm version)" ]; then
      nvm use
    fi
  elif [ -n "$(PWD=$OLDPWD nvm_find_nvmrc)" ] && [ "$(nvm version)" != "$(nvm version default)" ]; then
    echo "Reverting to nvm default version"
    nvm use default
  fi
}

add-zsh-hook chpwd load-nvmrc

load-nvmrc
