#!/bin/bash

# TODO Installs Homebew
brew install git ssh-copy-id bash-completion macvim multitail nmap tmux wget
# TODO Installs Server stuff (nginx, php53, pear, redis, memcached, what have you)

# Clears out the old .bash_profile
if [ -f ~/.bash_profile ];
then
	rm ~/.bash_profile
fi

PWD=`pwd`

# Adds paths and custom .bashrc
echo "
export PATH=\"$PWD/git:$PATH\"

if [ -f $PWD/bashrc ] && ! shopt -oq posix;
then
	. $PWD/bashrc
fi

if [ -f `brew --prefix`/etc/bash_completion ];
then
	. `brew --prefix`/etc/bash_completion
fi
" >> ~/.bash_profile

#./vim-setup.sh
