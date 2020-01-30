#!/usr/bin/env zsh

# export PATH=$HOME/.config/composer/vendor/bin:$PATH
export DOTFILES=$HOME/.dotfiles
export INCLUDES=$HOME/.local/share/dotfiles

source $DOTFILES/env
source $DOTFILES/aliases

eval `dircolors $DOTFILES/dircolors`

source $INCLUDES/zsh-autosuggestions/zsh-autosuggestions.zsh
source $INCLUDES/zsh-completions/zsh-completions.plugin.zsh
source $INCLUDES/zsh-history-substring-search/zsh-history-substring-search.zsh
source $INCLUDES/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh

ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE="fg=#586e75"

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

    if [ ! -z "$(git status --short)" ]; then
      echo " %F{red}✗"
    fi
  fi
}

vim_prompt() {
  if [ ! -z $VIMRUNTIME ]; then
    echo ":%F{green}sh ";
  fi
}

PS1='
$(vim_prompt)%F{blue}%~$(git_prompt)
%F{244}%# %F{reset}'

source $HOME/.fzf.zsh
