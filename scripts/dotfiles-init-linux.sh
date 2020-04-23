#!/usr/bin/env bash
DOTFILES_DIR=${DOTFILES_DIR:-$HOME/code/dotfiles}
GIT_REPO=${GIT_REPO:-yogendra/dotfiles}
if [[ -x $(command -v git) ]] 
then
  # If git is available
  if [[ ! -d $DOTFILES_DIR ]]
  then
    # DOTFILES_DIR does not exists
    echo Cloning dotfiles repo
    mkdir -p $DOTFILES_DIR
    [[ -d $HOME/.ssh ]] || mkdir -p $HOME/.ssh
    ssh-keyscan -H github.com >> $HOME/.ssh/known_hosts
    git clone -q git://github.com/${GIT_REPO}.git $DOTFILES_DIR
    
  elif [[ -d $DOTFILES_DIR/.git ]]
  then
    # DOTFILES_DIR exists and is connected to git    
    echo Update cloned dotfiles
    cd $DOTFILES_DIR
    git reset --hard
    git pull --rebase
    cd -
  else
    # DOTFILES_DIR exists but not connected to git    
    echo Connecting and updating dotfiles
    cd $DOTFILES_DIR
    git init
    git remote add origin  https://github.com/${GIT_REPO}.git
    git fetch origin
    git checkout -b master --track origin/master
    git reset origin/master
    cd -
  fi
else 
  # No git
  echo Download dotfile repo
  mkdir -p $DOTFILES_DIR
  wget -qO- https://github.com/$GIT_REPO/tarball/master | tar xz -C $DOTFILES_DIR
  REPO_SLUG=${GIT_REPO/\//-}
  REPO_DIRNAME=$(ls -1d $DOTFILES_DIR/${REPO_SLUG}-* | head -1)
  (shopt -s dotglob nullglob; mv $REPO_DIRNAME/* $DOTFILES_DIR)
  rm -rf $REPO_DIRNAME
fi

echo Setting Direnv
ln -fs $DOTFILES_DIR/root/.direnvrc ${HOME}/.direnvrc

echo Setting Vim
ln -fs ${DOTFILES_DIR}/root/.vimrc ${HOME}/.vimrc

echo Setting TMUX
ln -fs "${DOTFILES_DIR}/root/.tmux.conf" ${HOME}/.tmux.conf

echo Setting SSH
ln -fs $DOTFILES_DIR/root/.ssh $HOME/.ssh

echo Setting Bash shell
ln -fs $DOTFILES_DIR/root/.bashrc $HOME/.bashrc

echo Setting Git config
ln -fs $DOTFILES_DIR/root/.gitconfig $HOME/.gitconfig 
