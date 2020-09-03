#! /usr/bin/env bash
#-- Dave Wallraff

# First things first, I'm the realest...

## Set some vars
export DOTFILE_DIR=$HOME
export EDITOR="vim"
export GOPATH=$HOME/code/go
export PATH=$HOME/bin:$HOME/scripts:$GOPATH/bin:$HOME/.krew/bin:/usr/local/bin:/usr/bin:/bin:/sbin:/usr/sbin:/usr/local/sbin:~/.local/bin:/usr/local/go/bin

source $HOME/.aliases
# Set vi as line editor
set -o emacs

command -v direnv > /dev/null && eval "$(direnv hook bash)"
command -v starship > /dev/null && eval "$(starship init bash)"

if  command -v kubectl > /dev/null; then
    source <(kubectl completion bash)
    complete -F __start_kubectl k; 
fi

[ -f ~/.fzf.bash ] && source ~/.fzf.bash


[[ -f $HOME/.local/bin/gpg-agent-relay ]] && $HOME/.local/bin/gpg-agent-relay start
export SSH_AUTH_SOCK=$HOME/.gnupg/S.gpg-agent.ssh
