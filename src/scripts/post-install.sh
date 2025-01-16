#!/bin/bash

# System updates
brew update && brew upgrade && brew cleanup

printf "\n\n============================================================================\n\n"

cat "$(pwd)/src/assets/wolf.txt"

printf "\n\n============================================================================\n\n"

printf "\nPost-install Steps\n"

printf "
Download the following apps from the App Store.
    - Kindle
    - Perplexity
"

printf "
Run the following to enable Docker daemon on startup:
    sudo systemctl start docker.service
    sudo systemctl enable docker.service
    sudo usermod -aG docker %s
    newgrp docker\r" "$USER"

printf "\n\n============================================================================\n\n\r"

printf "Cheers -- system setup is now complete.\n\r"
printf "Log out and log back in to complete shell change.\n"
