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
ls -sf $DOTFILES_DIR/.direnvrc ${HOME}/.direnvrc

echo Setting Vim
ln -sf "${DOTFILES_DIR}/.vimrc" ${HOME}/.vimrc

echo Setting TMUX
ln -sf "${DOTFILES_DIR}/.tmux.conf" ${HOME}/.tmux.conf

echo Setting SSH
mkdir ~/.ssh
cat ${DOTFILES_DIR}/raw/keys | while read key; do
  wget -qO - "${key}" >> ${HOME}/.ssh/authorized_keys
done
sort $HOME/.ssh/authorized_keys | uniq > $HOME/.ssh/authorized_keys.uniq
ln -sf $DOTFILES_DIR/.ssh/config $HOME/.ssh/config
ln -sf $DOTFILES_DIR/.ssh/configs $HOME/.ssh/configs

echo Setting Bash shell
ln -sf $DOTFILES_DIR/.bashrc $HOME/.bashrc

echo Setting Git config
ln -sf $DOTFILES_DIR/.gitconfig $HOME/.gitconfig 

echo Created workspace directory
mkdir -p $PROJ_DIR/workspace/deployments
mkdir -p $PROJ_DIR/workspace/tiles


echo <<EOF
Create your SSH keys
===============================================================================
[[ ! -f ${HOME}/.ssh/id_rsa ]] && \
  ssh-keygen  -q -t rsa -N "" -f ${HOME}/.ssh/id_rsa && \
  cat ${HOME}/.ssh/id_rsa.pub >> ${HOME}/.ssh/authorized_keys

[[ ! -f ${HOME}/.ssh/id_dsa ]] && \
  ssh-keygen  -q -t dsa -N "" -f ${HOME}/.ssh/id_dsa && \
  cat ${HOME}/.ssh/id_dsa.pub  >> ${HOME}/.ssh/authorized_keys

EOF
