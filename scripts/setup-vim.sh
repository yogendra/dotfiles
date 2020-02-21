#!/usr/bin/env bash
# wget -q https://yogendra.me/setup-vim | bash
# Or
# curl -sL https://yogendra.me/setup-vim | bash
echo Setup VIM
mkdir -p .vim/autoload
wget -qO $HOME/.vim/autoload/plug.vim "https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim"
wget -q "https://gist.githubusercontent.com/yogendra/318c09f0cd2548bdd07f592722c9bbec/raw/.vimrc" -O $HOME/.vimrc 
