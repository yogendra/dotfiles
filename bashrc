#! /usr/bin/env bash
#-- Dave Wallraff

# First things first, I'm the realest...

## Set some vars
export EDITOR="vim"
export GOPATH=$HOME/code/go
export PATH=/usr/local/bin:/usr/bin:/bin:/sbin:/usr/sbin:/usr/local/sbin:~/.local/bin:/usr/local/go/bin:$GOPATH/bin
TODAY=$(date "+%Y%m%d") && export TODAY

## Write some functions

# Check for requirements
function check_command {

    if [ ! "$(command -v "$1")" ];
    then
        echo "command $1 was not found"
        return 1
    fi
}


# Create a slug from a string
# https://gist.github.com/oneohthree/f528c7ae1e701ad990e6
function slugify {

    echo "$1" | iconv -t ascii//TRANSLIT | sed -r s/[^a-zA-Z0-9]+/-/g | sed -r s/^-+\|-+$//g | tr '[:upper:]' '[:lower:]'
}



# Get info about my ip address
function ipinfo {

    if [ $# -eq 0 ]; then
        curl -s ip-api.com
    else
        curl -s ip-api.com/"$1"
    fi
}


# Get the weather
function weather {
    
    if [ $# -eq 0 ]; then
        LOC="$(ipinfo '' | jq .loc)"
        clear
        curl -s http://wttr.in/"$LOC"?FQ2
    else
        clear
        curl -s http://wttr.in/"$1"?FQ2
    fi
}


# Find out git branch for prompt
function parse_git_branch {

    ref=$(git symbolic-ref HEAD 2> /dev/null) || return
    echo "(${ref#refs/heads/})"
}


# Set some aliases
alias more="less"
alias ls="ls --color"
alias grep='grep --color=always'
alias less='less -R'
alias tmuxre='tmux new -ADs default'
alias jumpbox="mosh jumpbox -- tmux new -ADs jumpbox"
alias start_jumpbox="gcloud compute instances start jumpbox"
alias stop_jumpbox="gcloud compute instances stop jumpbox"

# Spelling is hard
alias histroy="history"
alias ptyhon=python
alias pyhton=ptyhon
alias sl=ls
alias alisa="alias"
alias vi=vim
alias auso=sudo
alias sudp=sudo

# Set vi as line editor
set -o emacs

# Prompts rule everything around me, PREAM, set the vars, $$ y'all
function prompt {
    local RESET='\[\e[0m\]'
    local blue='\[\e[36m\]'
    local red='\[\e[31m\]'
    local gold='\[\e[33m\]'
    export PS1="\n\`if [ \$? = 0 ]; then echo ${blue}; else echo ${red}; fi\`\u@\h\n ${blue}\w ${gold}\$(parse_git_branch)${blue} > ${RESET}"
}

prompt
eval "$(direnv hook bash)"
