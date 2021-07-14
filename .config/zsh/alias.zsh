# Simple shell aliasing

alias emacs="TERM=screen-256color emacsclient -t"
alias sumacs="sudo emacs -nw"

alias systemctl="sudo systemctl"
alias userctl="\systemctl --user"

alias reconf="source $HOME/.zshrc"

alias cp="cp --reflink=always"
