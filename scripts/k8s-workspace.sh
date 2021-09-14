#!/usr/bin/env sh
set -e 
wget -qO- https://yogendra.me/k8s-profile >> ~/.profile
wget -qO- https://yogendra.me/minimal-vimrc >> ~/.vimrc

source ~/.profile
