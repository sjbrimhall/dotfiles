export PATH=.:$HOME/.local/bin:$PATH

export GPG_TTY=$(tty)
gpg-connect-agent updatestartuptty /bye &> /dev/null

export EDITOR="emacsclient -t"
