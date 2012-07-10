# To use, simply add the following to:
#		/etc/bash.bashrc or ~/.bashrc (Linux)
#		~/.bash_profile (Mac OS X)
#
# if [ -f /path/to/this/bash.bashrc ] && ! shopt -oq posix;
# then
#     . /path/to/this/bash.bashrc
# fi

if [ `uname` == "Darwin" ];
then
	# Tell ls to be colourful
	export CLICOLOR=1
	export LSCOLORS=Exfxcxdxbxegedabagacad

	# Tell grep to highlight matches
	export GREP_OPTIONS='--color=auto'

	export   PATH=/usr/local/bin:/usr/local/sbin:$PATH
	export EDITOR="mvim -v"
else
	export   PATH="$HOME/Source/bash:$PATH"
	export EDITOR=vim
fi

export GIT_PS1_SHOWDIRTYSTATE=true
export GIT_PS1_SHOWSTASHSTATE=true
export GIT_PS1_SHOWUNTRACKEDFILE=true
export GIT_PS1_SHOWUPSTREAM="auto"

# Regular Colors
export     BLACK="\[\033[0;30m\]"
export       RED="\[\033[0;31m\]"
export     GREEN="\[\033[0;32m\]"
export    YELLOW="\[\033[0;33m\]"
export      BLUE="\[\033[0;34m\]"
export   MAGENTA="\[\033[0;35m\]"
export      CYAN="\[\033[0;36m\]"
export     WHITE="\[\033[0;37m\]"
export     RESET="\[\033[0;38m\]"

# Bold Colors
export   B_BLACK="\[\033[1;30m\]"
export     B_RED="\[\033[1;31m\]"
export   B_GREEN="\[\033[1;32m\]"
export  B_YELLOW="\[\033[1;33m\]"
export    B_BLUE="\[\033[1;34m\]"
export B_MAGENTA="\[\033[1;35m\]"
export    B_CYAN="\[\033[1;36m\]"
export   B_WHITE="\[\033[1;37m\]"

# Darker Colors
export   D_BLACK="\[\033[2;30m\]"
export     D_RED="\[\033[2;31m\]"
export   D_GREEN="\[\033[2;32m\]"
export  D_YELLOW="\[\033[2;33m\]"
export    D_BLUE="\[\033[2;34m\]"
export D_MAGENTA="\[\033[2;35m\]"
export    D_CYAN="\[\033[2;36m\]"
export   D_WHITE="\[\033[2;37m\]"

# Prompt
if [[ $EUID -ne 0 ]];
then
	if [[ $HOSTNAME == "aurora" ]];
	then
		export PS1="\n$D_WHITE\u$RESET@$D_MAGENTA\h$RESET:$B_BLUE\w\n$D_WHITE\$ $RESET"
	else
		export PS1="\n$D_WHITE\u$RESET@$D_MAGENTA\h$RESET:$B_BLUE\w$YELLOW\$(__git_ps1)\n$D_WHITE\$ $RESET"
	fi
else
	if [[ $HOSTNAME == "aurora" ]];
	then
		export PS1="\n$D_WHITE\u$RESET@$D_MAGENTA\h$RESET:$B_BLUE\w\n$B_RED# $RESET"
	else
		export PS1="\n$D_WHITE\u$RESET@$D_MAGENTA\h$RESET:$B_BLUE\w$YELLOW\$(__git_ps1)\n$B_RED# $RESET"
	fi
fi

export PS2="$D_WHITE> $RESET"

# Aliases

# apt-*
alias   ac="sudo apt-cache"
alias  acs="sudo apt-cache search"
alias   ag="sudo apt-get"
alias agar="sudo apt-get autoremove"
alias  agi="sudo apt-get install"
alias  agp="sudo apt-get purge"
alias  agr="sudo apt-get remove"
alias agud="sudo apt-get update"
alias agug="sudo apt-get upgrade"
alias aguu="sudo apt-get update && sudo apt-get upgrade"

# cd *
alias desktop="cd ~/Desktop"

# free
alias fm="free -m"

# git
alias    ga="git add"
alias   gaa="git add ."
alias    gb="git branch"
alias   gba="git branch -a"
alias    gc="git commit"
alias   gca="git commit -a"
alias   gcl="git clone"
alias   gco="git checkout"
alias  gcob="git checkout -B"
alias  gcom="git checkout master"
alias    gd="git diff"
alias   gdb="git delete-branch"
alias    gf="git fetch"
alias    gl="git log"
alias    gm="git merge"
alias   gmm="git merge master"
alias    gp="git push"
alias  gpoh="git push origin HEAD"
alias  gpom="git push origin master"
alias   gpu="git pull"
alias gpuoh="git pull origin HEAD"
alias gpuom="git pull origin master"
alias    gr="git remote"
alias   gra="git remote add"
alias  grao="git remote add origin"
alias   grr="git remote rm"
alias  grro="git remote rm origin"
alias   grm="git rm"
alias    gs="git status"

# memcached
alias mc="telnet localhost 11211"

# mysql
alias mycs="mysql crowdsavings"
alias mysk="mysql scenekids"

# service
alias service="sudo service"

# vim
if [ `uname` == "Darwin" ];
then
	alias vim='mvim -v'
	alias   v='mvim -v'
	alias  vd="mvimdiff -v"
	alias  vo="mvim -v -O"
else
	alias  v="vim"
	alias vd="vimdiff"
	alias vo="vim -O"
fi
