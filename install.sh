#!/bin/bash

# TODO check if fortune-mod is installed and if not, install it

# Clears out the old .bashrc
if [ -f ~/.bashrc ];
then
  	rm ~/.bashrc
fi

# Grabs the skeleton .bashrc
cp /etc/skel/.bashrc ~/.bashrc

PWD=`pwd`

# Adds paths
echo "export PATH=\"$PWD/git:$PATH\"" >> ~/.bashrc

# Appends the custom .bashrc file
echo "
if [ -f $PWD/bash.bashrc ] && ! shopt -oq posix; then
	. $PWD/bash.bashrc
fi" >> ~/.bashrc
