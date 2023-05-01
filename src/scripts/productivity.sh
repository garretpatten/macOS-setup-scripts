# Install taskwarrior
brew install task -y

# Update config file
cat ../artifacts/taskwarrior/taskrcUpdates.txt >> ~/.taskrc

# Add directory for custom themes
mkdir ~/.task/themes/

# TODO: Add custom themes to directory
# cp ./src/artifacts/taskwarrior/themes/ ~/.task/themes/

# Install Todoist
brew install --cask todoist

# Install Simplenote
brew install --cask simplenote
