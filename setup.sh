#!/bin/bash

# Adds some third party repos
sudo add-apt-repository ppa:tiheum/equinox          # Faenza Icons
#sudo add-apt-repository ppa:zedtux/naturalscrolling # Natural Scrolling
sudo add-apt-repository ppa:tualatrix/ppa           # Ubuntu Tweak

# Updates the package list
sudo apt-get update

# Gets rid of some bullshit packages
sudo apt-get --purge autoremove appmenu-gtk appmenu-gtk3 zeitgeist gwibber gnome-screensaver banshee

# Installs some applications
sudo apt-get install agave gimp inkscape tomboy rhythmbox chromium-browser shutter gnome-tweak-tool faenza-icon-theme network-manager-openconnect-gnome ubuntu-tweak

# Installs my dev stack
sudo apt-get install vim vim-gnome git-core ruby1.8-dev

# Installs all of our xmonad goodness
sudo apt-get install xmonad libghc6-xmonad-contrib-dev gnome-do xcompmgr xscreensaver

#sudo apt-get install xmobar trayer suckless-tools scrot cabal-install
#cabal update
#cabal install yeganesh

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

echo; echo "SETUP COMPLETE!!~!"
echo; echo "For further enhancement, do this: http://www.omgubuntu.co.uk/2011/10/use-adwaita-dark-as-your-system-theme/"
