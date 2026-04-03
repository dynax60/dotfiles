# Bat
alias bathelp='batcat --plain --language=help'
alias bat='batcat --paging=never'
help() {
    "$@" --help 2>&1 | bathelp
}

batdiff() {
    git diff --name-only --relative --diff-filter=d | xargs batcat --diff
}

export MANPAGER="sh -c 'col -bx | batcat -l man -p'"
