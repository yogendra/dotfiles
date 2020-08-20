#!/usr/bin/env bash

mkdir -p $HOME/bin
sudo apt-get update 
sudo apt-get install -qqy git wget direnv 
[[  -d $HOME/.dotfiles.git ]] ||  git clone --bare --git-dir $HOME/.dotfiles.git  https://github.com/${GIT_REPO}.git 

/usr/bin/git --git-dir=$HOME/.dotfiles.git/ --work-tree=$HOME checkout

curl -fsSL https://starship.rs/install.sh -o /tmp/starship-install.sh
bash /tmp/starship-install.sh -b $HOME/bin  -y
rm /tmp/starship-install.sh

git clone --depth 1 https://github.com/junegunn/fzf.git ~/.fzf
~/.fzf/install

/usr/bin/git --git-dir=$HOME/.dotfiles.git/ --work-tree=$HOME checkout

source $HOME/.bashrc

