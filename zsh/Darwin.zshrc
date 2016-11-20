#!/usr/bin/env zsh

antigen-bundle osx

export GREP_OPTIONS="--color=auto --exclude-dir=${GREP_EXCLUDE_DIR} --exclude-dir=.sass-cache"

source "`brew --prefix`/etc/grc.bashrc"
source $HOME/.rvm/scripts/rvm

# Requires sudo, saves a step
alias mtr="sudo mtr"

# Because macOS is dumb
alias mux="tmuxinator"

# Unquarantine files on OSX
alias unquarantine="xattr -r -d com.apple.quarantine *"

# Because OS X returns all caps
function uuidgen() {
  env uuidgen "$@" | awk '{print tolower($0)}'
}
