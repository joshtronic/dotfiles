#!/bin/bash

# TODO check if fortune-mod is installed and if not, install it

# Clears out the old .bashrc
if [ -f ~/.bashrc ];
then
  	rm ~/.bashrc
fi

# Grabs the skeleton .bashrc
cp /etc/skel/.bashrc ~/.bashrc

# Appends the custom .bashrc file
echo "
if [ -f `pwd`/bash.bashrc ] && ! shopt -oq posix; then
	. `pwd`/bash.bashrc
fi" >> ~/.bashrc
