DOTFILES := $(shell pwd)
OS := $(shell uname)

install: apt brew gem git grcat karabiner mysql plist tmux tmuxinator vim zsh X
.PHONEY: apt brew gem git grcat karabiner mysql plist tmux tmuxinator vim zsh X

tmux:
	ln -fs $(DOTFILES)/tmux.conf ${HOME}/.tmux.conf

tmuxinator:
	ln -fns $(DOTFILES)/tmuxinator ${HOME}/.tmuxinator
