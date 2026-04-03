#!/bin/bash

# System-wide preferences (Appearance, Dock, trackpad, menu bar, Night Shift,
# security, developer-oriented defaults, and Apple Silicon–friendly power tuning).
# Run on macOS; many changes apply after Dock / Finder / ControlCenter / SystemUIServer restart.

source "$(dirname "$0")/utils.sh"

if [[ "$OSTYPE" != "darwin"* ]]; then
    log_error "system-config.sh requires macOS"
    exit 1
fi

# --- Appearance & Interface ---
# Dark appearance (not automatic light/dark)
defaults write NSGlobalDomain AppleInterfaceStyle -string Dark 2>>"$ERROR_LOG_FILE" || true
defaults write NSGlobalDomain AppleInterfaceStyleSwitchesAutomatically -bool false 2>>"$ERROR_LOG_FILE" || true

# Sidebar icon size to small
defaults write NSGlobalDomain NSTableViewDefaultSizeMode -int 1 2>>"$ERROR_LOG_FILE" || true

# Snappier UI: fewer window animations (faster feedback for dev workflows)
defaults write NSGlobalDomain NSAutomaticWindowAnimationsEnabled -bool false 2>>"$ERROR_LOG_FILE" || true
defaults write NSGlobalDomain NSWindowResizeTime -float 0.001 2>>"$ERROR_LOG_FILE" || true

# --- Input: Keyboard & Trackpad ---
# Natural scroll direction OFF (classic / non-natural scrolling)
defaults write NSGlobalDomain com.apple.swipescrolldirection -bool false 2>>"$ERROR_LOG_FILE" || true
defaults -currentHost write NSGlobalDomain com.apple.swipescrolldirection -bool false 2>>"$ERROR_LOG_FILE" || true

# Maximum Key Repeat Rate & Shortest Delay
defaults write NSGlobalDomain KeyRepeat -int 1 2>>"$ERROR_LOG_FILE" || true
defaults write NSGlobalDomain InitialKeyRepeat -int 10 2>>"$ERROR_LOG_FILE" || true

# Full keyboard access (Tab through all controls)
defaults write NSGlobalDomain AppleKeyboardUIMode -int 3 2>>"$ERROR_LOG_FILE" || true

# Enable Three-Finger Drag
defaults write com.apple.driver.AppleBluetoothMultitouch.trackpad TrackpadThreeFingerDrag -bool true 2>>"$ERROR_LOG_FILE" || true

# --- Security & System Hardening (single sudo session) ---
sudo env ERROR_LOG_FILE="$ERROR_LOG_FILE" bash -c '
    /usr/libexec/ApplicationFirewall/socketfilterproxy --setglobalstate on 2>>"$ERROR_LOG_FILE" || true
    /usr/libexec/ApplicationFirewall/socketfilterproxy --setstealthmode on 2>>"$ERROR_LOG_FILE" || true
    defaults write /Library/Preferences/com.apple.loginwindow GuestEnabled -bool false 2>>"$ERROR_LOG_FILE" || true
    # Install macOS updates automatically (matches System Settings → General → Software Update → Advanced)
    defaults write /Library/Preferences/com.apple.SoftwareUpdate AutomaticallyInstallMacOSUpdates -bool true 2>>"$ERROR_LOG_FILE" || true
    # Apple Silicon (M3/M4): reliable wake, keep TCP sessions alive across sleep, allow Power Nap when appropriate
    pmset -a lidwake 1 2>>"$ERROR_LOG_FILE" || true
    pmset -a tcpkeepalive 1 2>>"$ERROR_LOG_FILE" || true
    pmset -a powernap 1 2>>"$ERROR_LOG_FILE" || true
'

# Prevent .DS_Store file creation on network or USB volumes
defaults write com.apple.desktopservices DSDontWriteNetworkStores -bool true 2>>"$ERROR_LOG_FILE" || true
defaults write com.apple.desktopservices DSDontWriteUSBStores -bool true 2>>"$ERROR_LOG_FILE" || true

# Enable automatic security-related updates
defaults write com.apple.SoftwareUpdate AutomaticCheckEnabled -bool true 2>>"$ERROR_LOG_FILE" || true
defaults write com.apple.SoftwareUpdate CriticalUpdateInstall -bool true 2>>"$ERROR_LOG_FILE" || true
defaults write com.apple.SoftwareUpdate ConfigDataInstall -bool true 2>>"$ERROR_LOG_FILE" || true

# Disable the "Are you sure you want to open this application?" quarantine dialog
defaults write com.apple.LaunchServices LSQuarantine -bool false 2>>"$ERROR_LOG_FILE" || true

# Disable Crash Reporter dialog
defaults write com.apple.CrashReporter DialogType -string "none" 2>>"$ERROR_LOG_FILE" || true

# Disable "Disk not ejected properly" notification (domain is com.apple.diskarbitrationd, not com.apple.DiskArbitration.*)
defaults write com.apple.diskarbitrationd DADisableEjectNotification -bool true 2>>"$ERROR_LOG_FILE" || true

# Require password immediately after sleep or screen saver begins
defaults write com.apple.screensaver askForPassword -int 1 2>>"$ERROR_LOG_FILE" || true
defaults write com.apple.screensaver askForPasswordDelay -int 0 2>>"$ERROR_LOG_FILE" || true

# --- Finder & Desktop ---
# Show all extensions, hidden files, and Path bar
defaults write NSGlobalDomain AppleShowAllExtensions -bool true 2>>"$ERROR_LOG_FILE" || true
defaults write com.apple.finder AppleShowAllFiles -bool true 2>>"$ERROR_LOG_FILE" || true
defaults write com.apple.finder ShowPathbar -bool true 2>>"$ERROR_LOG_FILE" || true
defaults write com.apple.finder FXPreferredViewStyle -string "clmv" 2>>"$ERROR_LOG_FILE" || true
defaults write com.apple.finder FXEnableExtensionChangeWarning -bool false 2>>"$ERROR_LOG_FILE" || true
defaults write com.apple.finder FXDefaultSearchScope -string "SCcf" 2>>"$ERROR_LOG_FILE" || true
defaults write com.apple.finder _FXShowPosixPathInTitle -bool true 2>>"$ERROR_LOG_FILE" || true

# Fast spring-loading when hovering over folders in Finder
defaults write NSGlobalDomain com.apple.springing.enabled -bool true 2>>"$ERROR_LOG_FILE" || true
defaults write NSGlobalDomain com.apple.springing.delay -float 0 2>>"$ERROR_LOG_FILE" || true

# Redirect screenshots and remove shadows
ensure_directory "$HOME/Pictures/Screenshots"
defaults write com.apple.screencapture location -string "$HOME/Pictures/Screenshots" 2>>"$ERROR_LOG_FILE" || true
defaults write com.apple.screencapture disable-shadow -bool true 2>>"$ERROR_LOG_FILE" || true

# --- Dock & Spotlight ---
# Automatically hide, minimize to app icon, hide recents; faster show/hide animations
defaults write com.apple.dock autohide -bool true 2>>"$ERROR_LOG_FILE" || true
defaults write com.apple.dock autohide-delay -float 0 2>>"$ERROR_LOG_FILE" || true
defaults write com.apple.dock autohide-time-modifier -float 0 2>>"$ERROR_LOG_FILE" || true
defaults write com.apple.dock minimize-to-application -bool true 2>>"$ERROR_LOG_FILE" || true
defaults write com.apple.dock show-recents -bool false 2>>"$ERROR_LOG_FILE" || true
defaults write com.apple.dock expose-animation-duration -float 0.1 2>>"$ERROR_LOG_FILE" || true

# Prioritize Spotlight categories
defaults write com.apple.spotlight orderedItems -array \
    '{"enabled" = 1;"name" = "APPLICATIONS";}' \
    '{"enabled" = 1;"name" = "SYSTEM_SETTINGS";}' \
    '{"enabled" = 1;"name" = "DIRECTORIES";}' 2>>"$ERROR_LOG_FILE" || true

# --- Menu bar (clock format; hide battery percentage) ---
defaults write com.apple.menuextra.clock DateFormat -string "EEE MMM d  h:mm" 2>>"$ERROR_LOG_FILE" || true
defaults write com.apple.menuextra.battery ShowPercent -bool false 2>>"$ERROR_LOG_FILE" || true
defaults write com.apple.controlcenter BatteryShowPercentage -bool false 2>>"$ERROR_LOG_FILE" || true

# --- Energy & Hardware (Night Shift + pmset already applied in sudo block above) ---
# Night Shift: enabled, warmest strength, sunset–sunrise (Type 2)
defaults write com.apple.CoreBrightness CBBlueLightReductionEnabled -bool true 2>>"$ERROR_LOG_FILE" || true
defaults write com.apple.CoreBrightness CBBlueLightReductionScheduleType -int 2 2>>"$ERROR_LOG_FILE" || true
defaults write com.apple.CoreBrightness CBBlueLightReductionStrength -float 1 2>>"$ERROR_LOG_FILE" || true

# --- Restart Services (ControlCenter + SystemUIServer pick up menu bar clock/battery prefs) ---
killall Dock >/dev/null 2>&1 || true
killall Finder >/dev/null 2>&1 || true
killall ControlCenter >/dev/null 2>&1 || true
killall SystemUIServer >/dev/null 2>&1 || true
killall mds >/dev/null 2>&1 || true
