
function
{
	if [[ -n "$SSH_CLIENT" ]];
	then
		case `hostname` in
			'aurora' )
				SERVER_PREFIX1='👸  ' ;;
			'belle' )
				SERVER_PREFIX1='👸  ' ;;
			'cinderella' )
				SERVER_PREFIX1='👸  ' ;;
			'swanson' )
				SERVER_PREFIX1='👨  ' ;;
			'yars' )
				SERVER_PREFIX1='👾  ' ;;
		esac

		SERVER_PREFIX2='📡  '
	else
		SERVER_PREFIX1=''
		SERVER_PREFIX2=''
	fi
}

SEPARATOR="%{$FG[238]%} ✱ "
TIME="%{$FG[028]%}%D{%H}%{$FG[022]%}:%{$FG[028]%}%D{%M}%{$FG[022]%}:%{$FG[028]%}%D{%S}"
USER="%{$FG[244]%}%n%{$FG[248]%}@%{$fg[magenta]%}%m"

PROMPT='
${SERVER_PREFIX1}%{$TIME%}%{$SEPARATOR%}%{$USER%}%{$SEPARATOR%}%{$fg_bold[blue]%}%~$(git_prompt_info)
${SERVER_PREFIX2}%{$FG[244]%}%# %{$reset_color%}'

ZSH_THEME_GIT_PROMPT_PREFIX=" %{$FG[011]%}("
ZSH_THEME_GIT_PROMPT_SUFFIX=""
ZSH_THEME_GIT_PROMPT_DIRTY=") %{$fg[red]%}✗%{$reset_color%}"
ZSH_THEME_GIT_PROMPT_CLEAN=")"
