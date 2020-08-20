set fish_greeting
set -x DOTFILES_DIR $HOME
set -x DOTFILES_OS (uname)
source  $DOTFILES_DIR/.aliases
source $DOTFILES_DIR/.aliases.$DOTFILES_OS

eval (direnv hook fish)
fzf_key_bindings
starship init fish | source
