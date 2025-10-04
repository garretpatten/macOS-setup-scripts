#!/bin/bash

# Common functions library for macOS setup scripts
# This file provides centralized functionality for installation, logging, and error handling

# Set script directory for consistent path handling
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(dirname "$(dirname "$SCRIPT_DIR")")"

# Logging configuration
LOG_DIR="$PROJECT_ROOT/logs"
ERROR_LOG="$LOG_DIR/errors.log"
INSTALL_LOG="$LOG_DIR/install.log"
DEBUG_LOG="$LOG_DIR/debug.log"

# Create logs directory if it doesn't exist
mkdir -p "$LOG_DIR"

# Log levels
readonly LOG_ERROR=1
readonly LOG_WARN=2
readonly LOG_INFO=3
readonly LOG_DEBUG=4

# Current log level (can be overridden by environment variable)
LOG_LEVEL=${LOG_LEVEL:-$LOG_INFO}

# Color codes for output
readonly RED='\033[0;31m'
readonly GREEN='\033[0;32m'
readonly YELLOW='\033[1;33m'
readonly BLUE='\033[0;34m'
readonly PURPLE='\033[0;35m'
readonly CYAN='\033[0;36m'
readonly NC='\033[0m' # No Color

# Logging functions
log() {
    local level="$1"
    local message="$2"
    local timestamp=$(date '+%Y-%m-%d %H:%M:%S')

    # Only log if level is within current log level
    if [[ $level -le $LOG_LEVEL ]]; then
        case $level in
            $LOG_ERROR)
                echo -e "${RED}[ERROR]${NC} $message" >&2
                echo "[$timestamp] [ERROR] $message" >> "$ERROR_LOG"
                ;;
            $LOG_WARN)
                echo -e "${YELLOW}[WARN]${NC} $message"
                echo "[$timestamp] [WARN] $message" >> "$INSTALL_LOG"
                ;;
            $LOG_INFO)
                echo -e "${GREEN}[INFO]${NC} $message"
                echo "[$timestamp] [INFO] $message" >> "$INSTALL_LOG"
                ;;
            $LOG_DEBUG)
                echo -e "${BLUE}[DEBUG]${NC} $message"
                echo "[$timestamp] [DEBUG] $message" >> "$DEBUG_LOG"
                ;;
        esac
    fi
}

log_error() { log $LOG_ERROR "$1"; }
log_warn() { log $LOG_WARN "$1"; }
log_info() { log $LOG_INFO "$1"; }
log_debug() { log $LOG_DEBUG "$1"; }

# Check if a command exists
command_exists() {
    command -v "$1" >/dev/null 2>&1
}

# Check if a Homebrew package is installed
is_brew_installed() {
    local package="$1"
    local package_type="${2:-formula}" # formula or cask

    if [[ "$package_type" == "cask" ]]; then
        brew list --cask "$package" >/dev/null 2>&1
    else
        brew list "$package" >/dev/null 2>&1
    fi
}

# Check if a directory exists
directory_exists() {
    [[ -d "$1" ]]
}

# Check if a file exists
file_exists() {
    [[ -f "$1" ]]
}

# Install a Homebrew formula
install_brew_formula() {
    local package="$1"
    local description="${2:-$package}"

    if is_brew_installed "$package" "formula"; then
        log_info "$description is already installed"
        return 0
    fi

    log_info "Installing $description..."
    if brew install "$package" 2>>"$ERROR_LOG"; then
        log_info "Successfully installed $description"
        return 0
    else
        log_error "Failed to install $description"
        return 1
    fi
}

# Install a Homebrew cask
install_brew_cask() {
    local package="$1"
    local description="${2:-$package}"

    if is_brew_installed "$package" "cask"; then
        log_info "$description is already installed"
        return 0
    fi

    log_info "Installing $description..."
    if brew install --cask "$package" 2>>"$ERROR_LOG"; then
        log_info "Successfully installed $description"
        return 0
    else
        log_error "Failed to install $description"
        return 1
    fi
}

# Install multiple Homebrew formulas in parallel
install_brew_formulas_parallel() {
    local packages=("$@")
    local pids=()
    local results=()

    log_info "Installing ${#packages[@]} formulas in parallel..."

    for package in "${packages[@]}"; do
        if ! is_brew_installed "$package" "formula"; then
            (
                if brew install "$package" 2>>"$ERROR_LOG"; then
                    log_info "Successfully installed $package"
                    exit 0
                else
                    log_error "Failed to install $package"
                    exit 1
                fi
            ) &
            pids+=($!)
        else
            log_info "$package is already installed"
        fi
    done

    # Wait for all background processes to complete
    for pid in "${pids[@]}"; do
        wait "$pid"
        results+=($?)
    done

    # Check if any installations failed
    local failed=0
    for result in "${results[@]}"; do
        if [[ $result -ne 0 ]]; then
            failed=1
        fi
    done

    return $failed
}

# Install multiple Homebrew casks in parallel
install_brew_casks_parallel() {
    local packages=("$@")
    local pids=()
    local results=()

    log_info "Installing ${#packages[@]} casks in parallel..."

    for package in "${packages[@]}"; do
        if ! is_brew_installed "$package" "cask"; then
            (
                if brew install --cask "$package" 2>>"$ERROR_LOG"; then
                    log_info "Successfully installed $package"
                    exit 0
                else
                    log_error "Failed to install $package"
                    exit 1
                fi
            ) &
            pids+=($!)
        else
            log_info "$package is already installed"
        fi
    done

    # Wait for all background processes to complete
    for pid in "${pids[@]}"; do
        wait "$pid"
        results+=($?)
    done

    # Check if any installations failed
    local failed=0
    for result in "${results[@]}"; do
        if [[ $result -ne 0 ]]; then
            failed=1
        fi
    done

    return $failed
}

# Create directory if it doesn't exist
ensure_directory() {
    local dir="$1"
    local description="${2:-directory}"

    if directory_exists "$dir"; then
        log_debug "$description already exists: $dir"
        return 0
    fi

    log_info "Creating $description: $dir"
    if mkdir -p "$dir" 2>>"$ERROR_LOG"; then
        log_info "Successfully created $description"
        return 0
    else
        log_error "Failed to create $description: $dir"
        return 1
    fi
}

# Copy file with error handling
copy_file() {
    local source="$1"
    local destination="$2"
    local description="${3:-file}"

    if ! file_exists "$source"; then
        log_warn "Source $description does not exist: $source - skipping copy"
        return 0
    fi

    # Create destination directory if it doesn't exist
    local dest_dir=$(dirname "$destination")
    ensure_directory "$dest_dir" "destination directory"

    log_info "Copying $description: $source -> $destination"
    if cp "$source" "$destination" 2>>"$ERROR_LOG"; then
        log_info "Successfully copied $description"
        return 0
    else
        log_error "Failed to copy $description"
        return 1
    fi
}

# Copy directory recursively with error handling
copy_directory() {
    local source="$1"
    local destination="$2"
    local description="${3:-directory}"

    if ! directory_exists "$source"; then
        log_warn "Source $description does not exist: $source - skipping copy"
        return 0
    fi

    # Create destination directory if it doesn't exist
    local dest_dir=$(dirname "$destination")
    ensure_directory "$dest_dir" "destination directory"

    log_info "Copying $description: $source -> $destination"
    if cp -r "$source" "$destination" 2>>"$ERROR_LOG"; then
        log_info "Successfully copied $description"
        return 0
    else
        log_error "Failed to copy $description"
        return 1
    fi
}

# Clone git repository with error handling
clone_repository() {
    local repo_url="$1"
    local destination="$2"
    local description="${3:-repository}"

    if directory_exists "$destination"; then
        log_info "$description already exists: $destination"
        return 0
    fi

    # Create parent directory if it doesn't exist
    local parent_dir=$(dirname "$destination")
    ensure_directory "$parent_dir" "parent directory"

    log_info "Cloning $description: $repo_url"
    if git clone "$repo_url" "$destination" 2>>"$ERROR_LOG"; then
        log_info "Successfully cloned $description"
        return 0
    else
        log_error "Failed to clone $description"
        return 1
    fi
}

# Execute command with error handling and logging
execute_command() {
    local command="$1"
    local description="${2:-command}"
    local log_output="${3:-true}"

    log_info "Executing: $description"
    log_debug "Command: $command"

    if [[ "$log_output" == "true" ]]; then
        if eval "$command" 2>>"$ERROR_LOG"; then
            log_info "Successfully executed: $description"
            return 0
        else
            log_error "Failed to execute: $description"
            return 1
        fi
    else
        if eval "$command" >/dev/null 2>>"$ERROR_LOG"; then
            log_info "Successfully executed: $description"
            return 0
        else
            log_error "Failed to execute: $description"
            return 1
        fi
    fi
}

# Check if running on macOS
check_macos() {
    if [[ "$OSTYPE" != "darwin"* ]]; then
        log_error "This script is designed for macOS only. Current OS: $OSTYPE"
        exit 1
    fi
}

# Check if Homebrew is installed
check_homebrew() {
    if ! command_exists "brew"; then
        log_error "Homebrew is not installed. Please install Homebrew first."
        exit 1
    fi
}

# Initialize Homebrew
init_homebrew() {
    log_info "Initializing Homebrew..."

    # Update Homebrew
    execute_command "brew update" "Homebrew update"
    execute_command "brew upgrade" "Homebrew upgrade"
    execute_command "brew cleanup" "Homebrew cleanup"

    # Disable analytics
    execute_command "brew analytics off" "Disable Homebrew analytics"
}

# Print section header
print_section() {
    local title="$1"
    echo
    echo -e "${PURPLE}============================================================================${NC}"
    echo -e "${PURPLE}$title${NC}"
    echo -e "${PURPLE}============================================================================${NC}"
    echo
}

# Print completion message
print_completion() {
    local message="$1"
    echo
    echo -e "${GREEN}============================================================================${NC}"
    echo -e "${GREEN}$message${NC}"
    echo -e "${GREEN}============================================================================${NC}"
    echo
}

# Cleanup function for trap
cleanup() {
    log_info "Cleaning up..."
    # Add any cleanup logic here
}

# Set up signal handlers
trap cleanup EXIT INT TERM

# Export functions for use in other scripts
export -f log_error log_warn log_info log_debug
export -f command_exists is_brew_installed directory_exists file_exists
export -f install_brew_formula install_brew_cask
export -f install_brew_formulas_parallel install_brew_casks_parallel
export -f ensure_directory copy_file copy_directory clone_repository
export -f execute_command check_macos check_homebrew init_homebrew
export -f print_section print_completion

# Export variables
export LOG_DIR ERROR_LOG INSTALL_LOG DEBUG_LOG
export SCRIPT_DIR PROJECT_ROOT
