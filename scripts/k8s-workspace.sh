#!/usr/bin/env sh
set -e
curl -L https://yogendra.me/k8s-profile >> ~/.profile
curl -L https://yogendra.me/minimal-vimrc >> ~/.vimrc

source ~/.profile
