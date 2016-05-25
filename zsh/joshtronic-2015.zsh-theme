function username() {
  if [[ `whoami` != 'josh' ]]; then
    echo %{$FG[248]%}%n
  fi
}

function server() {
  if [[ `hostname` != Joshs-* ]]; then
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
