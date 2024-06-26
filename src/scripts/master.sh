#!/bin/bash

sh "$(pwd)/src/scripts/pre-install.sh"

# Home directory customization
sh "$(pwd)/src/scripts/organizeHome.sh"

# CLI tools
sh "$(pwd)/src/scripts/cli.sh"

# Browsers
sh "$(pwd)/src/scripts/web.sh"

# Streaming and video applications
bash "$(pwd)/src/scripts/media.sh"

# Productivity programs
sh "$(pwd)/src/scripts/productivity.sh"

# Security and privacy utilities
sh "$(pwd)/src/scripts/security.sh"

# IDE setup
sh "$(pwd)/src/scripts/ide.sh"

# Dev tools
sh "$(pwd)/src/scripts/dev.sh"

# Penetration testing tools and wordlists
sh "$(pwd)/src/scripts/hacking.sh"

# Shell setup
zsh "$(pwd)/src/scripts/shell.sh"

sh "$(pwd)/src/scripts/post-install.sh"
