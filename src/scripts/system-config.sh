#!/bin/bash

# System-wide preferences (Appearance, Dock, trackpad scrolling, Night Shift).
# Run on macOS; many changes apply after Dock / SystemUIServer restart.

source "$(dirname "$0")/utils.sh"

if [[ "$OSTYPE" != "darwin"* ]]; then
    log_error "system-config.sh requires macOS"
    exit 1
fi

# Dark appearance (not automatic light/dark)
defaults write NSGlobalDomain AppleInterfaceStyle -string Dark 2>>"$ERROR_LOG_FILE" || true
defaults write NSGlobalDomain AppleInterfaceStyleSwitchesAutomatically -bool false 2>>"$ERROR_LOG_FILE" || true

# Natural scroll direction OFF (classic / non-natural scrolling)
defaults write NSGlobalDomain com.apple.swipescrolldirection -bool false 2>>"$ERROR_LOG_FILE" || true
defaults -currentHost write NSGlobalDomain com.apple.swipescrolldirection -bool false 2>>"$ERROR_LOG_FILE" || true

# Dock: automatically hide and show; minimize windows into application icon
defaults write com.apple.dock autohide -bool true 2>>"$ERROR_LOG_FILE" || true
defaults write com.apple.dock minimize-to-application -bool true 2>>"$ERROR_LOG_FILE" || true

# Night Shift: enabled, warmest strength, sunset–sunrise schedule
# (Solar times use location; ensure Settings → Privacy → Location Services allows “Setting Time Zone” / system services as needed.)
defaults write com.apple.CoreBrightness CBBlueLightReductionEnabled -bool true 2>>"$ERROR_LOG_FILE" || true
# Schedule type values are not documented by Apple; 2 is commonly used for solar (sunset–sunrise) in community scripts.
defaults write com.apple.CoreBrightness CBBlueLightReductionScheduleType -int 2 2>>"$ERROR_LOG_FILE" || true
defaults write com.apple.CoreBrightness CBBlueLightReductionStrength -float 1 2>>"$ERROR_LOG_FILE" || true

killall Dock >/dev/null 2>&1 || true
killall SystemUIServer >/dev/null 2>&1 || true
