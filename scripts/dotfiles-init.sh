#!/usr/bin/env bash
DOTFILES_DIR=${DOTFILES_DIR:-$HOME/code/dotfiles}
if [[ ! -d $DOTFILES_DIR ]]
then
  mkdir $DOTFILES_DIR
  git clone https://github.com/${GIT_REPO}.git $DOTFILES_DIR
  export $DOTFILES_DIR/scripts
else
  (cd $DOTFILES_DIR; git reset --hard; git pull --rebase)
fi

echo Setting Direnv
ln -fs $DOTFILES_DIR/.direnvrc ${HOME}/.direnvrc

echo Setting Vim
ln -fs "${DOTFILES_DIR}/.vimrc" ${HOME}/.vimrc

echo Setting TMUX
ln -fs "${DOTFILES_DIR}/.tmux.conf" ${HOME}/.tmux.conf

echo Setting SSH
mkdir ~/.ssh
cat ${DOTFILES_DIR}/raw/keys | while read key; do
  wget -qO - "${key}" >> ${HOME}/.ssh/authorized_keys
done
sort $HOME/.ssh/authorized_keys | uniq > $HOME/.ssh/authorized_keys.uniq
ln -fs $DOTFILES_DIR/.ssh/config $HOME/.ssh/config
ln -fs $DOTFILES_DIR/.ssh/configs $HOME/.ssh/configs

echo Setting Bash shell
ln -fs $DOTFILES_DIR/.bashrc $HOME/.bashrc

echo Setting Git config
ln -fs $DOTFILES_DIR/.gitconfig $HOME/.gitconfig 
