# My Personal Dotfiles

This repository contains my personal configuration files for various tools, primarily focused on creating a consistent and efficient development environment.

## Overview

These dotfiles configure:
- Neovim (with Lua-based configuration)
- Tmux (terminal multiplexer)
- Zsh (with Oh My Zsh)
- fzf (command-line fuzzy finder)
- Various shell aliases and settings

## Setup

1.  **Clone the repository:**
    ```bash
    git clone https://github.com/username/dotfiles.git ~/dotfiles
    # Replace <repository_url> with the actual URL of this repo
    cd ~/dotfiles
    ```

2.  **Run the setup script:**
    ```bash
    ./setup.sh
    ```
    The `setup.sh` script will:
    - Check for necessary dependencies (like `zsh`, `curl`, `git`).
    - Install Oh My Zsh, fzf, and nvm (Node Version Manager) if they are not already present.
    - Create symbolic links for the configuration files in this repository to their appropriate locations in your home directory (e.g., `~/.config/nvim`, `~/.tmux.conf`).
    - Install some useful Rust-based command-line tools (`bat`, `ripgrep`) if Rust is installed.

## Requirements

- **zsh:** The setup script assumes `zsh` is or will be your default shell.
- **git:** For cloning the repository and installing some tools.
- **curl:** For downloading installers.
- **A C compiler (e.g., gcc):** Needed for `fzf` installation and potentially other tools.
- **Rust (optional):** If you want to install the Rust-based command-line tools (`bat`, `ripgrep`), you'll need the Rust toolchain (including `cargo`).

## Neovim Configuration

The Neovim setup is located in the `nvim/` directory and is written in Lua. Key features include:
- [Lazy.nvim](https://github.com/folke/lazy.nvim) for plugin management.
- LSP (Language Server Protocol) support via `nvim-lspconfig`.
- Autocompletion with `nvim-cmp`.
- File navigation with `nvim-tree` and `telescope.nvim`.
- Treesitter for syntax highlighting and code parsing.
- Formatting via `conform.nvim` (which uses `stylua` for Lua).

## Customization

Feel free to fork this repository and customize it to your own needs. The `setup.sh` script and Neovim configurations are good places to start.

## Included Dotfiles

This repository manages symlinks for:
- `~/.aliases`
- `~/.tmux.conf`
- `~/.bash_profile` (primarily for tmux compatibility)
- `~/.agignore`
- `~/.ignore`
- `~/.gitconfig`
- `~/.inputrc`
- `~/.pylintrc`
- `~/.config/nvim/init.lua` and `~/.config/nvim/lua/`
- `~/.gdbinit`
- `~/.ctags`

(Note: Some files like `_vimrc` are legacy and not actively symlinked by the current `setup.sh`.)

---
