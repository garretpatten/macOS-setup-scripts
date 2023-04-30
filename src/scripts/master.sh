# Install HomeBrew
# https://brew.sh/
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

# Begin: System Updates
brew update && brew upgrade && brew cleanup

# CLI Tooling
sh ./scripts/cli.sh

# Productivity: Taskwarrior, Todoist
sh ./scripts/productivity.sh

# TODO: Web

# TODO: Dev

# Shell
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
