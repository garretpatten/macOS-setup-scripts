# TODO: Install Office suite

# Install Simplenote
brew install --cask simplenote

# TODO: Install Spectacle

# Install taskwarrior
brew install task

# Taskwarrior config
cat ../artifacts/taskwarrior/taskrcUpdates.txt >> ~/.taskrc

# Add directory for custom themes
mkdir ~/.task/themes/

# TODO: Add custom themes to directory
# cp ./src/artifacts/taskwarrior/themes/ ~/.task/themes/

# Install Todoist
brew install --cask todoist
