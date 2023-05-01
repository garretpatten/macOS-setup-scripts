# Install HomeBrew
# https://brew.sh/
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

# Begin: System Updates
brew update && brew upgrade && brew cleanup

# Security: Firewall, VPN, Anti-Virus
sh ./security.sh

# CLI Tooling
sh ./scripts/cli.sh

# Productivity: Simplenote, Taskwarrior, Todoist
sh ./scripts/productivity.sh

# Web: Brave & Firefox
sh ./web.sh

# Development Setup: Git, Postman, Sourcegraph, Vim, VS Code
sh ./dev.sh

# Shell: iTerm2, zsh, oh-my-zsh
sh ./shell.sh

# Other
sh ./misc.sh

# Add Taskwarrior tasks
sh ./addTasks.sh

# End: System Updates
brew update && brew upgrade && brew cleanup

# Create a break in output
echo ''
echo ''
echo ''

echo "Cheers -- system setup is now complete!"
