#!/bin/bash

PWD=`pwd`

# Copies .gitconfig
if [ -f ~/.gitconfig ];
then
	rm ~/.gitconfig
fi

ln -s $PWD/gitconfig ~/.gitconfig

if [ `uname` == 'Darwin' ];
then
	# TODO Installs Homebew
	brew install git ssh-copy-id bash-completion macvim multitail nmap tmux wget htop
	# TODO Installs Server stuff (nginx, php53, pear, redis, memcached, what have you)

	# Clears out the old .bash_profile
	if [ -f ~/.bash_profile ];
	then
		rm ~/.bash_profile
	fi

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

else
	# TODO Add prompts so I can run pieces of the set up

	# Adds some third party repos
	sudo add-apt-repository ppa:tiheum/equinox          # Faenza Icons
	sudo add-apt-repository ppa:tualatrix/ppa           # Ubuntu Tweak
	sudo add-apt-repository ppa:webupd8team/gnome3      # WebUpd8 Gnome Extensions
	sudo add-apt-repository ppa:otto-kesselgulasch/gimp # Gimp 2.8

	# Updates the package list
	sudo apt-get update

	# Gets rid of some bullshit packages
	#sudo apt-get --purge autoremove appmenu-gtk appmenu-gtk3 zeitgeist gwibber gnome-screensaver banshee

	# Installs CLI apps
	sudo apt-get install vim ssh multitail htop iotop tmux

	# Installs desktop environment
	sudo apt-get install gnome-shell gnome-tweak-tool faenza-icon-theme network-manager-openconnect-gnome gnome-sushi gnome-shell-extensions-mediaplayer gnome-shell-extensions-noa11y gnome-shell-classic-systray gnome-shell-message-notifier gnome-shell-extension-notesearch

	# Installs non-CLI apps
	sudo apt-get install gnome-agave gimp inkscape tomboy rhythmbox chromium-browser shutter ubuntu-tweak vim-gnome

	# Installs my dev stack
	sudo apt-get install git-core ruby1.8-dev nginx apache2 php5 php5-cgi php5-cli php-pear php5-suhosin psmisc spawn-fcgi mysql-server php5-mysql redis-server memcached php5-memcache php5-memcached php5-gd php5-curl php5-imagick exim4-daemon-light

	# TODO Installs my server stack

	# Configures some stuff
	sudo a2enmod expires rewrite ssl
	sudo service apache2 restart

	# Clears out the old .bashrc
	if [ -f ~/.bashrc ];
	then
		rm ~/.bashrc
	fi

	# Grabs the skeleton .bashrc
	cp /etc/skel/.bashrc ~/.bashrc

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
fi

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
