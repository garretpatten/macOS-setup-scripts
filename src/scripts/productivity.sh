# Install taskwarrior
brew install task -y

# Update config file
cat ../artifacts/taskwarrior/taskrcUpdates.txt >> ~/.taskrc

# Add directory for custom themes
mkdir ~/.task/themes/

# TODO: Add custom themes to directory
# cp ./src/artifacts/taskwarrior/themes/ ~/.task/themes/

# Download and mount Todoist installer
wget https://todoist.com/mac_app -O ~/Downloads/todoist-installer.dmg
sudo hdiutil mount ~/Downloads/todoist-installer.dmg

# Copy Todoist to Applications directory
cd /Volumes/Todoist*
pathToTodoist="pwd"
sudo cp -R "$pathToTodoist/Todoist.app" /Applications/

# Return home, unmount and delete Todoist installer
cd
hdiutil unmount "$pathToTodoist"
rm ~/Downloads/todoist-installer.dmg
