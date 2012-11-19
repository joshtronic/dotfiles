#!/bin/bash

PWD=`pwd`

# Copies .vimrc
if [ -f ~/.vimrc ];
then
	rm ~/.vimrc
fi

ln -s $PWD/vimrc ~/.vimrc

# Pulls down and installs vim plugins
DOTVIM=~/.vim

if [ -d $DOTVIM ];
then
	rm -r $DOTVIM
fi

mkdir $DOTVIM

echo

OWNERS=( "ervandew" "msanders"     "scrooloose" "scrooloose" "tpope"        "vim-scripts" "vim-scripts"              "vim-scripts"    )
REPOS=(  "supertab" "snipmate.vim" "nerdtree"   "syntastic"  "vim-fugitive" "Command-T"   "Flex-Development-Support" "SearchComplete" )

for (( i = 0 ; i < ${#OWNERS[@]} ; i++ ))
do
	git clone git://github.com/${OWNERS[$i]}/${REPOS[$i]}.git /tmp/${REPOS[$i]}
	cp -R /tmp/${REPOS[$i]}/* $DOTVIM
	rm -rf /tmp/${REPOS[$i]}
	echo
done

# Installs additional syntax files
cp ./less.vim $DOTVIM/syntax

# Finish up Command-T installation
cd $DOTVIM/ruby/command-t
ruby extconf.rb
make
