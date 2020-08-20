
#! /usr/bin/env bash
#-- Dave Wallraff

# First things first, I'm the realest...

## Set some vars
export DOTFILE_DIR=$HOME
export EDITOR="vim"
export GOPATH=$HOME/code/go
export PATH=$HOME/bin:$DOTFILE_DIR/scripts:$GOPATH/bin:/usr/local/bin:/usr/bin:/bin:/sbin:/usr/sbin:/usr/local/sbin:~/.local/bin:/usr/local/go/bin:${HOME}/.krew/bin

fpath=($DOTFILE_DIR/.zsh/completion $fpath)

# Set vi as line editor
set -o emacs

command -v direnv > /dev/null && eval "$(direnv hook bash)"
if  command -v kubectl > /dev/null; then
    source <(k completion bash)
    complete -F __start_kubectl k; 
fi

command -v starship > /dev/null eval "$(starship init zsh)"
[ -f ~/.fzf.bash ] && source ~/.fzf.bash

source $DOTFILE_DIR/.aliases

source <(k completion zsh); 
    complete -F __start_kubectl k            
fi

autoload -Uz compinit && compinit -i
