#!/bin/bash

# shellcheck source=../utils.sh
source "$(dirname "$0")/../utils.sh"
# shellcheck source=../lib/dotfiles-install.sh
source "$(dirname "$0")/../lib/dotfiles-install.sh"

link_dotfiles_xdg_config_dirs
install_dotfiles_from_manifest "$(dirname "$0")/dotfiles.manifest"
