# Install Sourcegraph CLI
brew install sourcegraph/src-cli/src-cli
brew upgrade src-cli


# Git config
git config --global credential.helper cache
git config --global user.email "garret.patten@proton.me"
git config --global user.name "Garret Patten"
git config pull.rebase false

# Install VS Code
brew install --cask visual-studio-code

# Install Postman
brew install --cask postman
