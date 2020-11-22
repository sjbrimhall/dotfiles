export PATH=.:$HOME/.local/bin:$PATH

export GPG_TTY=$(tty)
export SSH_AUTH_SOCK=$(gpgconf --list-dirs agent-ssh-socket)
gpg-connect-agent updatestartuptty /bye &> /dev/null

export EDITOR="emacsclient -t"
