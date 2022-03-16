set -gx DOTFILES_OS (uname | tr '[:upper:]' '[:lower:]')
set -gx DOTFILES_ARCH (uname -m | sed -e 's/x86_64/amd64/' -e 's/\(arm\)\(64\)\?.*/\1\2/' -e 's/aarch64\$/arm64/')
set -gx DOTFILES_CONF_DIR $HOME/.config/dotfiles
set -gx DOTFILES_CONFIG_DIR $DOTFILES_CONF_DIR
set -gx DOTFILES_SHELL "fish"

set fish_greeting

source $HOME/.exports
source $HOME/.exports.$DOTFILES_OS
source $HOME/.aliases
source $HOME/.aliases.$DOTFILES_OS

fzf_key_bindings
direnv hook fish | source
direnv export fish | source
starship init fish | source
