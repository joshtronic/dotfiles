#!/bin/bash

DOTVIM=~/.vim

rm -r $DOTVIM
mkdir $DOTVIM

OWNERS=( "tomtom"          "scrooloose" "msanders"     "ervandew" )
REPOS=(  "checksyntax_vim" "nerdtree"   "snipmate.vim" "supertab" )

for (( i = 0 ; i < ${#OWNERS[@]} ; i++ ))
do
	git clone git://github.com/${OWNERS[$i]}/${REPOS[$i]}.git /tmp/${REPOS[$i]}
	cp -R /tmp/${REPOS[$i]}/* $DOTVIM
	rm -rf /tmp/${REPOS[$i]}
done
