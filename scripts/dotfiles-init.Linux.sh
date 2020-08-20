#!/usr/bin/env bash

GIT_REPO=${GIT_REPO:-yogendra/dotfiles}

mkdir -p $HOME/bin

sudo apt-get update 
sudo apt-get install -qqy git wget direnv 
[[  -d $HOME/.dotfiles.git ]] ||  git clone --bare --branch master --depth=1 --no-tags  https://github.com/${GIT_REPO}.git $HOME/.dotfiles.git

git --git-dir=$HOME/.dotfiles.git/ --work-tree=$HOME checkout --force

curl -fsSL https://starship.rs/install.sh | bash -s -- -b $HOME/bin  -y

git clone --depth 1 https://github.com/junegunn/fzf.git $HOME/.fzf
$HOME/.fzf/install --all --key-bindings --completion --no-update-rc --64

source $HOME/.bashrc

