#!/bin/bash

# Clears out the old .bashrc
if [ -f ~/.bashrc ];
then
	rm ~/.bashrc
fi

# Grabs the skeleton .bashrc
cp /etc/skel/.bashrc ~/.bashrc

PWD=`pwd`

# Adds paths and custom .bashrc
echo "
export PATH=\"$PWD/git:$PATH\"

if [ -f $PWD/bashrc ] && ! shopt -oq posix; then
	. $PWD/bashrc
fi" >> ~/.bashrc

# Removes the existing scripts
if [ -d ~/.gnome2/nautilus-scripts ];
then
	rm ~/.gnome2/nautilus-scripts -rf
fi

# Symlinks back to our scripts
ln -s $PWD/nautilus-scripts ~/.gnome2/nautilus-scripts

# Sets up xmonad
if [ -d ~/.xmonad ];
then
	rm ~/.xmonad -rf
fi

cp $PWD/xmonad ~/.xmonad -R

# Adds it to the session list
if [ ! -f /usr/share/gnome-session/sessions/xmonad.desktop ]; then
	sudo cp "$PWD/xmonad.session" /usr/share/gnome-session/sessions
fi

if [ ! -f /usr/share/xsessions/xmonad-gnome.desktop ]; then
	sudo cp "$PWD/xmonad-gnome.desktop" /usr/share/xsessions
fi

# Copies .vimrc
if [ -f ~/.vimrc ];
then
	rm ~/.vimrc
fi

cp $PWD/vimrc ~/.vimrc

# Pulls down and installs vim plugins
DOTVIM=~/.vim

if [ -d $DOTVIM ];
then
	rm -r $DOTVIM
fi

mkdir $DOTVIM

OWNERS=( "ervandew" "msanders"     "nvie"            "scrooloose" "scrooloose" "tpope"        "vim-scripts" )
REPOS=(  "supertab" "snipmate.vim" "vim-togglemouse" "nerdtree"   "syntastic"  "vim-fugitive" "Command-T"   )

for (( i = 0 ; i < ${#OWNERS[@]} ; i++ ))
do
	git clone git://github.com/${OWNERS[$i]}/${REPOS[$i]}.git /tmp/${REPOS[$i]}
	cp -R /tmp/${REPOS[$i]}/* $DOTVIM
	rm -rf /tmp/${REPOS[$i]}
done

# Finish up Command-T installation
cd $DOTVIM/ruby/command-t
ruby extconf.rb
make
