git_prompt() {
  BRANCH=$(git rev-parse --abbrev-ref HEAD 2>/dev/null)

  if [ ! -z $BRANCH ]; then
    echo -n " %F{yellow}$BRANCH"

    STATUS=$(git status --short 2> /dev/null)

    if [ ! -z "$STATUS" ]; then
      echo " %F{red}✗"
    fi
  fi
}

PS1='
%F{blue}%~$(git_prompt)
%F{244}%# %F{reset}'
