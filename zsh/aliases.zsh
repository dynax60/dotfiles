alias n=nvim

eval "$(uvx --generate-shell-completion zsh)"

# Bat
alias bathelp='batcat --plain --language=help'
help() {
    "$@" --help 2>&1 | bathelp
}

batdiff() {
    git diff --name-only --relative --diff-filter=d | xargs batcat --diff
}

export MANPAGER="sh -c 'col -bx | batcat -l man -p'"

# Password generator
pwgen() {
  local len=${1:-20}
  LC_ALL=C tr -dc 'A-Za-z0-9@#%^&*()_+=-{}[]:;<>,.?/' < /dev/urandom | head -c "$len" | xargs echo
}
