#!/usr/bin/env bash
# wget -q https://yogendra.me/setup-vim | bash
# Or
# curl -sL https://yogendra.me/setup-vim | bash
echo Setup VIM
mkdir -p .vim/autoload
curl -sSL "https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim" -o $HOME/.vim/autoload/plug.vim
curl -sSL "https://raw.githubusercontent.com/yogendra/dotfiles/master/.vimrc.full" -o $HOME/.vimrc
