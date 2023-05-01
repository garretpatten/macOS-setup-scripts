# Install Xcode Command Line Tools and accept license
sudo rm -rf /Library/Developer/CommandLineTools
sudo xcode-select --install
sudo xcodebuild -license accept

# Git config
git config --global credential.helper cache
git config --global user.email "garret.patten@proton.me"
git config --global user.name "Garret Patten"
git config pull.rebase false

# Vim config
cat "$(pwd)/src/artifacts/vim/vimrc.txt" >> ~/.vimrc

# Install Sourcegraph App & CLI
brew install sourcegraph/app/sourcegraph
brew install sourcegraph/src-cli/src-cli

# Install Postman
brew install --cask postman

# Install VS Code
brew install --cask visual-studio-code
