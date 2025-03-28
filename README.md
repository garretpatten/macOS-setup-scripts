# Mac OS Setup Scripts
This repository contains a collections of scripts that I use to set up my personal Mac OS environments.

# Instructions

## How to Use

### Clone the repository

```bash
git clone https://github.com/garretpatten/macOS-setup-scripts
```

### Checkout the root of the project

```bash
cd macOS-setup-scripts
```

### Update submodules

```bash
git submodule update --init --remote --recursive src/dotfiles/
```

### Make the scripts executable

```bash
chmod +x src/scripts/*.sh
```

### Run the master script

```bash
bash src/scripts/master.sh
```

# Information

## Downloads

### Payload Lists

- [PayloadsAllTheThings](https://github.com/swisskyrepo/PayloadsAllTheThings)
- [SecLists](https://github.com/danielmiessler/SecLists)

## Installations

### Development

#### CLI

- docker, docker-compose, gh, neovim, node, npm, nvm, python, pip, semgrep, shellcheck, src-cli

#### GUI

- Postman
- Sourcegraph
- VS Code

### General CLI Tools

- bat
- curl
- eza
- fastfetch
- fd
- git
- htop
- jq
- ripgrep
- tmux
- vim
- wget

### Media

#### GUI

- Brave
- Duck Duck Go
- Spotify
- VLC

### Productivity

#### GUI

- Balena Etcher
- Chat GPT
- Notion
- Proton Drive
- Proton Mail
- Raycast
- Zoom

### Security

#### CLI

- clamscan
- exiftool
- nmap
- op
- openvpn

#### GUI

- 1Password
- Burp Suite
- OWASP ZAP
- Proton VPN
- Signal Messenger

## Configurations

- Alacritty
- Ghostty
- Git
- Mac OS Firewall
- Neovim
- System
- Vim
- VS Code
- Z Shell

### Shell

#### CLI

- oh-my-posh
- zsh

#### Fonts

- Awesome Terminal Fonts
- Fira Code Fonts
- Meslo Nerd Fonts
- Powerline Fonts (and Symbols)

#### Plugins

- Zsh Auto Suggestions
- Zsh Syntax Highlighting

## Maintainers

[@garretpatten](https://github.com/garretpatten/)

For questions, bug reports, or feature requests, please open an issue on this repository or contact the maintainer directly.

## License
This project is licensed under the [MIT License](https://opensource.org/licenses/MIT). See full license at [LICENSE](./LICENSE).
