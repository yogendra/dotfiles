#!/usr/bin/env sh
set -e
curl -sSL https://yogendra.me/k8s-profile >> ~/.profile
curl -sSL https://yogendra.me/minimal-vimrc >> ~/.vimrc

source ~/.profile
