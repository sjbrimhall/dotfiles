export PATH_pyenv=$HOME/.pyenv/shims:/opt/pyenv/pyenv-virtualenv/shims
export PATH_java=/usr/lib/jvm/default/bin
export PATH_perl=/usr/bin/vendor_perl:/usr/bin/core_perl
export PATH_system=/usr/local/sbin:/usr/local/bin:/usr/bin
export PATH_user=$HOME/.local/bin

export PATH=.:$PATH_pyenv:$PATH_user:$PATH_system:$PATH_java:$PATH_perl

export GPG_TTY=$(tty)
export SSH_AUTH_SOCK=$(gpgconf --list-dirs agent-ssh-socket)
gpg-connect-agent updatestartuptty /bye &> /dev/null

export EDITOR="emacsclient -t"
