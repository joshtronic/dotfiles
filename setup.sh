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
	ln -s ~/Dropbox/Pictures/Git\ Shots ~/.gitshots

	# Installs Homebrew
	if [ `which brew` == '' ];
	then
		ruby <(curl -fsSkL raw.github.com/mxcl/homebrew/go)
		mkdir -p ~/Library/LaunchAgents
	fi

	# Gets our `brew` on
	brew install bash-completion git htop imagemagick imagesnap macvim memcached multitail mysql nginx nmap redis ssh-copy-id wget flex_sdk postgresql

	# Allows htop to show all processes
	sudo chown root:wheel /usr/local/Cellar/htop-osx/0.8.2/bin/htop
	sudo chmod u+s /usr/local/Cellar/htop-osx/0.8.2/bin/htop

	# Initializes databasesL
	mysql_install_db --verbose --user=`whoami` --basedir="$(brew --prefix mysql)" --datadir=/usr/local/var/mysql --tmpdir=/tmp

	initdb /usr/local/var/postgres

	# Sets up our LaunchAgent
	launchctl unload -w ~/Library/LaunchAgents/homebrew.mxcl.memcached.plist
	cp /usr/local/Cellar/memcached/1.4.15/homebrew.mxcl.memcached.plist ~/Library/LaunchAgents/
	launchctl load -w ~/Library/LaunchAgents/homebrew.mxcl.memcached.plist

	launchctl unload -w ~/Library/LaunchAgents/homebrew.mxcl.redis.plist
	cp /usr/local/Cellar/redis/2.4.17/homebrew.mxcl.redis.plist ~/Library/LaunchAgents/
	launchctl load -w ~/Library/LaunchAgents/homebrew.mxcl.redis.plist

	launchctl unload -w ~/Library/LaunchAgents/homebrew.mxcl.postgresql.plist
	cp /usr/local/Cellar/postgresql/9.2.1/homebrew.mxcl.postgresql.plist ~/Library/LaunchAgents/
	launchctl load -w ~/Library/LaunchAgents/homebrew.mxcl.postgresql.plist

	# `brew`s up some PHP 5.3
	brew tap homebrew/dupes
	brew tap josegonzalez/homebrew-php

	# Backs up the stock OSX version of PHP
	if [ ! -f /usr/libexec/apache2/libphp5.so.orig ];
	then
		sudo mv /usr/libexec/apache2/libphp5.so /usr/libexec/apache2/libphp5.so.orig
	fi

	brew remove php53
	rm ~/.pearrc
	launchctl unload -w ~/Library/LaunchAgents/homebrew-php.josegonzalez.php53.plist
	rm ~/Library/LaunchAgents/homebrew-php.josegonzalez.php53.plist

	# Installs PHP as an Apache module
	brew install php53 --with-mysql --with-suhosin
	sudo cp /usr/local/Cellar/php53/5.3.16/libexec/apache2/libphp5.so /usr/libexec/apache2/libphp5.so
	brew remove php53

	# Installs PHP for Nginx (via FPM)
	brew install php53 --with-fpm --with-mysql --with-pgsql --with-suhosin
	cp /usr/local/Cellar/php53/5.3.16/homebrew-php.josegonzalez.php53.plist ~/Library/LaunchAgents/
	launchctl load -w ~/Library/LaunchAgents/homebrew-php.josegonzalez.php53.plist

	# Gets PHP how we like it
	brew install php53-imagick php53-mcrypt php53-memcache --with-homebrew-php

	brew linkapps

	# Clears out the old .bash_profile
	if [ -f ~/.bash_profile ];
	then
		rm ~/.bash_profile
	fi

	# Adds paths and custom .bashrc
	echo "
export PATH=\"/usr/local/sbin:$PWD/git/scripts:/usr/local/Cellar/flex_sdk/4.6.0.23201/libexec/bin:$PATH\"

if [ -f $PWD/bashrc ] && ! shopt -oq posix;
then
	. $PWD/bashrc
fi

if [ -f `brew --prefix`/etc/bash_completion ];
then
	. `brew --prefix`/etc/bash_completion
fi
" >> ~/.bash_profile

	# Installs my git hooks
	sudo ln -s $PWD/git/hooks/post-commit /usr/local/share/git-core/templates/hooks/post-commit
else
	# Gives us access to `add-apt-repository`
	sudo apt-get install python-software-properties

	# Adds the PostgreSQL repository so we can install 9.2
	sudo add-apt-repository ppa:pitti/postgresql

	# Updates the package list
	sudo apt-get update

	# Purges PostgreSQL 9.1 just in case
	# Seems this tries to remove 9.2 as well, leaving in just in case I need to run it
	# sudo apt-get --purge remove postgresql postgresql-9.1 postgresql-client-9.1 postgresql-client-common postgresql-common postgresql-doc postgresql-doc-9.1

	# Installs CLI apps
	sudo apt-get install vim ssh multitail htop iotop git-core ruby1.8-dev nginx php5 php5-cgi php5-cli php-pear php5-suhosin php5-fpm redis-server memcached php5-memcache php5-memcached php5-gd php5-curl php5-imagick php5-pgsql exim4-daemon-light postgresql-9.2

	# Clears out the old .bashrc
	if [ -f ~/.bashrc ];
	then
		rm ~/.bashrc
	fi

	# Grabs the skeleton .bashrc
	cp /etc/skel/.bashrc ~/.bashrc

	# Adds paths and custom .bashrc
	echo "
export PATH=\"$PWD/git/scripts:$PATH\"

if [ -f $PWD/bashrc ] && ! shopt -oq posix; then
	. $PWD/bashrc
fi" >> ~/.bashrc
fi

./vim.sh

echo; echo "SETUP COMPLETE!!~!"
