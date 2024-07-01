#!/bin/bash

sh "$(pwd)/src/scripts/pre-install.sh"

# Home directory customization
sh "$(pwd)/src/scripts/organizeHome.sh"

# CLI tools
sh "$(pwd)/src/scripts/cli.sh"

# Streaming and video applications
bash "$(pwd)/src/scripts/media.sh"

# Productivity programs
sh "$(pwd)/src/scripts/productivity.sh"

# Security and privacy utilities
sh "$(pwd)/src/scripts/security.sh"

# Dev tools
sh "$(pwd)/src/scripts/dev.sh"

# Shell setup
zsh "$(pwd)/src/scripts/shell.sh"

sh "$(pwd)/src/scripts/post-install.sh"
