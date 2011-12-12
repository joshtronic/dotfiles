# To use, simply add the following to /etc/bash.bashrc or ~/.bashrc
#
# if [ -f /path/to/this/bash.bashrc ] && ! shopt -oq posix; then
#     . /path/to/this/bash.bashrc
# fi

export   PATH="$HOME/Source/bash:$PATH"
export EDITOR=vim

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
		echo $HOSTNAME
		export PS1="\n$D_CYAN╷┏ $D_GREEN\t$RESET:$D_WHITE\u$RESET@$D_MAGENTA\h$RESET:$B_BLUE\w\n$D_CYAN╵┗ $D_WHITE\$ $RESET"
	else
		export PS1="\n$D_CYAN╷┏ $D_GREEN\t$RESET:$D_WHITE\u$RESET@$D_MAGENTA\h$RESET:$B_BLUE\w$YELLOW\$(__git_ps1)\n$D_CYAN╵┗ $D_WHITE\$ $RESET"
		fortune
	fi
else
	if [[ $HOSTNAME == "aurora" ]];
	then
		export PS1="\n$B_RED╷┏ $D_GREEN\t$RESET:$D_WHITE\u$RESET@$D_MAGENTA\h$RESET:$B_BLUE\w\n$B_RED╵┗ $D_WHITE# $RESET"
	else
		export PS1="\n$B_RED╷┏ $D_GREEN\t$RESET:$D_WHITE\u$RESET@$D_MAGENTA\h$RESET:$B_BLUE\w$YELLOW\$(__git_ps1)\n$B_RED╵┗ $D_WHITE# $RESET"
	fi
fi

export PS2="$D_WHITE> $RESET"

# Aliases

# apt-*
alias      ac="sudo apt-cache"
alias      ag="sudo apt-get"
# cd *
alias desktop="cd ~/Desktop"
# git
alias      ga="git add"
alias     gaa="git add ."
alias      gc="git commit"
alias     gca="git commit -a"
alias     gco="git checkout"
alias    gcob="git checkout -B"
alias    gcom="git checkout master"
alias      gd="git diff"
alias      gf="git fetch"
alias      gm="git merge"
alias     gmm="git merge master"
alias      gp="git push"
alias    gpoh="git push origin HEAD"
alias    gpom="git push origin master"
alias     gpu="git pull"
alias   gpuoh="git pull origin HEAD"
alias   gpuom="git pull origin master"
alias      gr="git remote"
alias     gra="git remote add"
alias    grao="git remote add origin"
alias     grr="git remote rm"
alias    grro="git remote rm origin"
alias     grm="git rm"
alias      gs="git status"
# mysql
alias     msk="mysql scenekids"
# service
alias service="sudo service"
