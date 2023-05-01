# Install iTerm2
brew install --cask iterm2

# Install Zsh
sudo brew install zsh

# Change User Shells to Zsh
chsh -s $(which zsh)
sudo chsh -s $(which zsh)

# Install oh-my-zsh
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"

# Install plugins
cd ~/.oh-my-zsh/custom/plugins
git clone https://github.com/zsh-users/zsh-autosuggestions.git
git clone https://github.com/zsh-users/zsh-syntax-highlighting.git

cat ../artifacts/zsh/zshrc.txt > ~/.zshrc
