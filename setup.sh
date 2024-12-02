#!/bin/bash

set -e

function add_line() {
    local text="$1"
    local file="$2"
    if ! grep -qF "$text" "$file"; then
       echo "Adding $text to $file"
       echo "$text" >> "$file"
       echo >> "$file" # add empty line
    fi
}

# Bootstrap

# Check OS
if [ "$OSTYPE" = "linux-gnu" ]; then
    OS_RELEASE=$(awk -F= '/^NAME/{print $2}' /etc/os-release)
    OS_ARCH=$(uname -m | sed 's/x86_//;s/i[3-6]86/32/')
    echo "$OSTYPE:$OS_RELEASE:$OS_ARCH"
elif [[ "$OSTYPE" == "darwin"* ]]; then
    echo "Darwin"
    echo 'Installing tmux italic tmux ...'
    tic xterm-256color-italic.terminfo
elif [ "$OSTYPE" == "freebsd"* ]; then
    exit "not supported"
fi

# Check shell
if [[ $SHELL == *"zsh" ]]; then
    # add aliases if not exist
    add_line "[ -f ~/.aliases ] && source ~/.aliases" ~/.zshrc
else
    exit "$SHELL not supported, please install zsh"
fi

# Install required tools
if [ ! -d ~/.oh-my-zsh ]; then
    sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
fi

if [ ! -d ~/.fzf ]; then
    git clone --depth 1 https://github.com/junegunn/fzf.git ~/.fzf
    ~/.fzf/install
fi

if [ ! -d ~/.nvm ]; then
    curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.7/install.sh | bash
fi

function install_dotfiles() {
    local CUR_DIR=$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )

    echo 'Installing dot files ...'
    # shell independent aliases, could be source by all shells
    ln -s -f $CUR_DIR/_aliases ~/.aliases
    # legacy vim configurations
    # ln -s -f $CUR_DIR/_vimrc ~/.vimrc
    ln -s -f $CUR_DIR/_tmux.conf ~/.tmux.conf
    ln -s -f $CUR_DIR/_bash_profile ~/.bash_profile # for tmux
    ln -s -f $CUR_DIR/_agignore ~/.agignore
    ln -s -f $CUR_DIR/_ignore ~/.ignore
    ln -s -f $CUR_DIR/_gitconfig ~/.gitconfig
    ln -s -f $CUR_DIR/_inputrc ~/.inputrc
    ln -s -f $CUR_DIR/_pylintrc ~/.pylintrc
    ln -s -f $CUR_DIR/_npmrc ~/.npmrc
    mkdir -p ~/.config/nvim
    # ln -s -f $CUR_DIR/nvim/coc-settings.json ~/.config/nvim/coc-settings.json
    # ln -s -f $CUR_DIR/nvim/init.vim ~/.config/nvim/init.vim
    ln -s -f $CUR_DIR/nvim/init.lua ~/.config/nvim/init.lua
    rm ~/.config/nvim/lua
    ln -s $CUR_DIR/nvim/lua ~/.config/nvim/lua
    rm ~/.config/nvim/syntax
    ln -s $CUR_DIR/nvim/syntax ~/.config/nvim/syntax

    ln -s -f $CUR_DIR/_gdbinit ~/.gdbinit
    ln -s -f $CUR_DIR/_ctags ~/.ctags
}

install_dotfiles

# install rust command line tools
echo 'Updating rust commandline tools ...'
if [ -d ~/.cargo/bin ]; then
  cargo install --locked bat
  cargo install ripgrep

  add_line "export FZF_DEFAULT_COMMAND='rg --files --hidden --follow'" ~/.zshrc
else
  echo 'Rust toolchain not installed, ignore ...'
fi
