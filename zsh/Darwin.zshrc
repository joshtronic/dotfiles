antigen-bundle osx

export GREP_OPTIONS="--color=auto --exclude-dir=${GREP_EXCLUDE_DIR} --exclude-dir=.sass-cache"

source "`brew --prefix`/etc/grc.bashrc"

# Unquarantine files on OSX
alias unquarantine="xattr -r -d com.apple.quarantine *"

# Requires sudo, saves a step
alias mtr="sudo mtr"

# Because OS X returns all caps
function uuidgen() {
  env \
    uuidgen "$@" | awk '{print tolower($0)}'
}
