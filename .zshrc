
#! /usr/bin/env bash
#-- Dave Wallraff

# First things first, I'm the realest...

## Set some vars
source $HOME/.zsh-init
export DOTFILES_OS=$(uname | tr '[:upper:]' '[:lower:]')
export DOTFILES_ARCH=$(uname -m | sed -e 's/x86_64/amd64/' -e 's/\(arm\)\(64\)\?.*/\1\2/' -e 's/aarch64\$/arm64/')
export DOTFILES_CONF_DIR=$HOME/.config/dotfiles
export DOTFILES_CONFIG_DIR=$DOTFILES_CONF_DIR
export DOTFILES_SHELL "zsh"

export EDITOR="vim"
export GOPATH=$HOME/code/go
export PATH=$HOME/bin:$DOTFILES_DIR/scripts:$GOPATH/bin:/usr/local/bin:/usr/bin:/bin:/sbin:/usr/sbin:/usr/local/sbin:~/.local/bin:/usr/local/go/bin:${HOME}/.krew/bin

fpath=($DOTFILES_DIR/.zsh/completion $fpath)

# Set vi as line editor
set -o emacs

if  command -v kubectl > /dev/null; then
    source <(k completion bash)
    complete -F __start_kubectl k;
fi

command -v direnv > /dev/null && eval "$(direnv hook bash)" && eval "$(direnv export bash)"
command -v starship > /dev/null eval "$(starship init zsh)"
[ -f ~/.fzf.bash ] && source ~/.fzf.bash

source $HOME/.exports
source $HOME/.exports.$DOTFILES_OS
source $HOME/.aliases
source $HOME/.aliases.$DOTFILES_OS


source <(k completion zsh);
    complete -F __start_kubectl k
fi

autoload -Uz compinit && compinit -i
