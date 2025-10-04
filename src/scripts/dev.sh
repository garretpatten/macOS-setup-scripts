#!/bin/bash

# Source common functions
source "$(dirname "$0")/common.sh"

# Check prerequisites
check_macos
check_homebrew

print_section "Installing Development Tools"

### Runtimes ###
log_info "Installing development runtimes..."

runtime_formulas=(
    "node"
    "python@3.12"
)

install_brew_formulas_parallel "${runtime_formulas[@]}"

# Install NVM
log_info "Installing NVM..."
execute_command "curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.7/install.sh | bash" "NVM installation"

### Development Tools ###
log_info "Installing development tools..."

dev_formulas=(
    "colima"
    "docker"
    "docker-compose"
    "gh"
    "neovim"
    "semgrep"
    "shellcheck"
    "tree-sitter"
    "angular-cli"
)

dev_casks=(
    "postman"
    "visual-studio-code"
)

# Install from custom taps
log_info "Installing tools from custom taps..."
execute_command "brew install sourcegraph/app/sourcegraph" "Sourcegraph App"
execute_command "brew install src-cli" "Sourcegraph CLI"

install_brew_formulas_parallel "${dev_formulas[@]}"
install_brew_casks_parallel "${dev_casks[@]}"

# Start Colima
log_info "Starting Colima..."
execute_command "colima start" "Start Colima"

### Editor Configuration ###
log_info "Configuring editors..."

# Install Packer for Neovim
clone_repository "https://github.com/wbthomason/packer.nvim" "$HOME/.local/share/nvim/site/pack/packer/start/packer.nvim" "Packer.nvim"

# Configure Neovim
ensure_directory "$HOME/.config/nvim" "Neovim config directory"
copy_directory "$PROJECT_ROOT/src/dotfiles/nvim" "$HOME/.config/nvim" "Neovim configuration"

# Configure Vim
if file_exists "$PROJECT_ROOT/src/dotfiles/vim/.vimrc"; then
    copy_file "$PROJECT_ROOT/src/dotfiles/vim/.vimrc" "$HOME/.vimrc" "Vim configuration"
else
    log_warn "Vim configuration not found, creating basic config"
    cat > "$HOME/.vimrc" << 'EOF'
" Basic vim configuration
set number
set relativenumber
set tabstop=4
set shiftwidth=4
set expandtab
set autoindent
set smartindent
set hlsearch
set incsearch
set ignorecase
set smartcase
set showmatch
set ruler
set laststatus=2
set statusline=%F%m%r%h%w\ [FORMAT=%{&ff}]\ [TYPE=%Y]\ [POS=%l,%v][%p%%]\ [BUFFER=%n]\ %{strftime('%c')}
syntax on
filetype plugin indent on
EOF
    log_info "Created basic vim configuration"
fi

# Configure VS Code
ensure_directory "$HOME/Library/Application Support/Code/User" "VS Code config directory"
copy_file "$PROJECT_ROOT/src/dotfiles/vs-code/settings.json" "$HOME/Library/Application Support/Code/User/settings.json" "VS Code settings"

### Git Configuration ###
log_info "Configuring Git..."

# Configure Git settings
execute_command "git config --global credential.helper store" "Git credential helper"
execute_command "git config --global http.postBuffer 157286400" "Git HTTP buffer"
execute_command "git config --global pack.window 1" "Git pack window"
execute_command "git config --global user.email 'garret.patten@proton.me'" "Git user email"
execute_command "git config --global user.name 'Garret Patten'" "Git user name"
execute_command "git config --global pull.rebase false" "Git pull strategy"

print_completion "Development Tools Installation Complete"
