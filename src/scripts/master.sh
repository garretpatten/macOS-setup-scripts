# Pre-Install
sh "$(pwd)/src/scripts/pre-install.sh"

# Organize Directories
sh ./organizeHome.sh

# Install HomeBrew
# https://brew.sh/
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

# Begin: System Updates
brew update && brew upgrade && brew cleanup

# Security: Firewall, VPN, Anti-Virus
sh "$(pwd)/src/scripts/security.sh"

# CLI Tooling
sh "$(pwd)/src/scripts/cli.sh"

# Productivity: Simplenote, Taskwarrior, Todoist
sh "$(pwd)/src/scripts/productivity.sh"

# Web: Brave & Firefox
sh "$(pwd)/src/scripts/web.sh"

# Development Setup: Git, Postman, Sourcegraph, Vim, VS Code
sh "$(pwd)/src/scripts/dev.sh"

# Shell: iTerm2, zsh, oh-my-zsh
sh "$(pwd)/src/scripts/shell.sh"

# Other
sh "$(pwd)/src/scripts/misc.sh"

# Add Taskwarrior tasks
sh "$(pwd)/src/scripts/addTasks.sh"

# End: System Updates
brew update && brew upgrade && brew cleanup

# Create a break in output
echo ''
echo ''
echo ''

echo "Cheers -- system setup is now complete!"
