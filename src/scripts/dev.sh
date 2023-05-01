# Git config
git config --global credential.helper cache
git config --global user.email "garret.patten@proton.me"
git config --global user.name "Garret Patten"
git config pull.rebase false

# Vim config
cat ../artifacts/vim/vimrc.txt >> ~/.vimrc


# Install Sourcegraph CLI
brew install sourcegraph/src-cli/src-cli
brew upgrade src-cli

# Install Postman
brew install --cask postman

# Install VS Code
brew install --cask visual-studio-code

# Install Xcode
