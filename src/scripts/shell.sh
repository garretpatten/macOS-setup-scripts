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
if file_exists "$PROJECT_ROOT/src/dotfiles/tmux/.tmux.conf"; then
    copy_file "$PROJECT_ROOT/src/dotfiles/tmux/.tmux.conf" "$HOME/.tmux.conf" "Tmux config"
else
    log_warn "Tmux configuration not found, creating basic config"
    cat > "$HOME/.tmux.conf" << 'EOF'
# Basic tmux configuration
set -g default-terminal "screen-256color"
set -g mouse on
set -g history-limit 10000
set -g base-index 1
setw -g pane-base-index 1
bind-key C-a send-prefix
bind-key | split-window -h
bind-key - split-window -v
EOF
    log_info "Created basic tmux configuration"
fi

# Zsh configuration
if file_exists "$PROJECT_ROOT/src/dotfiles/oh-my-posh/.zshrc"; then
    copy_file "$PROJECT_ROOT/src/dotfiles/oh-my-posh/.zshrc" "$HOME/.zshrc" "Zsh config"
else
    log_warn "Zsh configuration not found, creating basic config"
    cat > "$HOME/.zshrc" << 'EOF'
# Basic zsh configuration
export PATH="/opt/homebrew/bin:$PATH"

# Oh My Posh
eval "$(oh-my-posh init zsh --config $(brew --prefix oh-my-posh)/themes/jandedobbeleer.omp.json)"

# Zsh plugins
source /opt/homebrew/share/zsh-autosuggestions/zsh-autosuggestions.zsh
source /opt/homebrew/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh

# Aliases
alias ll="eza -la"
alias la="eza -a"
alias l="eza"
alias cat="bat"
alias find="fd"
alias grep="rg"
EOF
    log_info "Created basic zsh configuration"
fi

# Change default shell to zsh
log_info "Changing default shell to zsh..."
execute_command "chsh -s $(which zsh)" "Change user shell to zsh"
execute_command "sudo chsh -s $(which zsh)" "Change root shell to zsh"

print_completion "Shell and Terminal Tools Installation Complete"
