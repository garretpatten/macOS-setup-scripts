#!/bin/bash

# Source common functions
source "$(dirname "$0")/common.sh"

# Check prerequisites
check_macos
check_homebrew

print_section "Installing Shell and Terminal Tools"

### Shells ###
log_info "Installing shell applications..."

shell_formulas=(
    "ghostty"
    "zsh"
    "tmux"
    "zsh-autosuggestions"
    "zsh-syntax-highlighting"
)

# Install oh-my-posh from custom tap
log_info "Installing oh-my-posh..."
execute_command "brew install jandedobbeleer/oh-my-posh/oh-my-posh" "oh-my-posh"

install_brew_formulas_parallel "${shell_formulas[@]}"

### Fonts ###
log_info "Installing terminal fonts..."

# Add font tap
execute_command "brew tap homebrew/cask-fonts" "Add font tap"

font_casks=(
    "font-awesome-terminal-fonts"
    "font-fira-code"
    "font-meslo-lg-nerd-font"
    "font-powerline-symbols"
)

install_brew_casks_parallel "${font_casks[@]}"

### Configuration ###
log_info "Configuring shell and terminal applications..."

# Ghostty configuration
ensure_directory "$HOME/.config/ghostty" "Ghostty config directory"
copy_file "$PROJECT_ROOT/src/dotfiles/ghostty/config" "$HOME/.config/ghostty/config" "Ghostty config"

# Tmux configuration
copy_file "$PROJECT_ROOT/src/dotfiles/tmux/.tmux.conf" "$HOME/.tmux.conf" "Tmux config"

# Zsh configuration
copy_file "$PROJECT_ROOT/src/dotfiles/oh-my-posh/.zshrc" "$HOME/.zshrc" "Zsh config"

# Change default shell to zsh
log_info "Changing default shell to zsh..."
execute_command "chsh -s $(which zsh)" "Change user shell to zsh"
execute_command "sudo chsh -s $(which zsh)" "Change root shell to zsh"

print_completion "Shell and Terminal Tools Installation Complete"
