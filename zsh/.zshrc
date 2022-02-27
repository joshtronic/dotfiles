#!/usr/bin/env zsh

# Speed up `brew install`
export HOMEBREW_NO_AUTO_UPDATE=1

source $HOME/.env
source $HOME/.aliases

eval `dircolors $HOME/.dircolors`

# TODO: May need to tweak this for macOS/brew installed stuff
source /usr/share/fzf/completion.zsh
source /usr/share/fzf/key-bindings.zsh
source /usr/share/zsh/plugins/zsh-history-substring-search/zsh-history-substring-search.zsh
source /usr/share/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh

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

# Only autoload nvm on a specific machine, default to lazy loading
# TODO: Maybe drop the lazy loading entirely as I never use nvm outside of work?
if [[ $(hostname) == "x1carbon.josh" ]]; then
  export NVM_DIR="$([ -z "${XDG_CONFIG_HOME-}" ] \
    && printf %s "${HOME}/.nvm" || printf %s "${XDG_CONFIG_HOME}/nvm")"
  [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
else
  # Run `nvm` init script on demand to avoid constant slow downs
  function nvm {
    if [ -z ${NVM_DIR+x} ]; then
      export NVM_DIR="$HOME/.nvm"

      if [ -s "$NVM_DIR/nvm.sh" ]; then
        source "$NVM_DIR/nvm.sh"
      elif [ -s "/usr/share/nvm/init-nvm.sh" ]; then
        source /usr/share/nvm/init-nvm.sh
      fi

      nvm "$@"
    fi
  }
fi
