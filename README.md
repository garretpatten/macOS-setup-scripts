# macOS Setup Scripts

Bash-based automation for provisioning a development-focused macOS environment on Apple Silicon (M-series) Macs: Homebrew installs, shell and dotfiles, and system-wide defaults.

## Features

- **Modular scripts**: Run the full stack with `master.sh` or run individual phases (CLI, dev, media, and so on).
- **Shared helpers**: `utils.sh` centralizes paths, `log_error`, safe copy/download helpers, and a single error log path.
- **System defaults**: `system-config.sh` applies appearance, input, Finder, Dock, Spotlight, menu bar (clock/battery), Night Shift, security-related settings, and Apple Silicon–friendly `pmset` tuning (see below).
- **CI**: GitHub Actions runs the scripts on `macos-latest` (with `pre-install.sh` skipped in the workflow for speed).

## Quick start

### Prerequisites

- macOS (recent versions; scripts assume Darwin)
- Network access for Homebrew and downloads
- Administrator privileges when `sudo` is required (for example firewall, guest account, system Software Update plist, and `pmset` in `system-config.sh`)

### Installation

1. **Clone the repository**

   ```bash
   git clone https://github.com/garretpatten/macOS-setup-scripts
   cd macOS-setup-scripts
   ```

2. **Update submodules** (for dotfiles)

   ```bash
   git submodule update --init --remote --recursive src/dotfiles/
   ```

3. **Make scripts executable**

   ```bash
   chmod +x src/scripts/*.sh
   ```

4. **Run the full setup**

   ```bash
   bash src/scripts/master.sh
   ```

### Individual scripts

Examples:

```bash
bash src/scripts/system-config.sh   # macOS defaults only (no Homebrew)
bash src/scripts/cli.sh
bash src/scripts/dev.sh
bash src/scripts/media.sh
bash src/scripts/productivity.sh
bash src/scripts/security.sh
zsh src/scripts/shell.sh
bash src/scripts/organizeHome.sh
```

## Project structure

```text
macOS-setup-scripts/
├── .github/workflows/
│   └── test-runner.yaml      # CI: runs scripts on macOS runners
├── src/
│   ├── scripts/
│   │   ├── utils.sh          # Paths, logging, safe copy/download helpers
│   │   ├── master.sh         # Orchestrates all phases in order
│   │   ├── pre-install.sh    # Homebrew, Xcode CLT, updates (skipped in CI)
│   │   ├── system-config.sh  # defaults write, firewall, pmset; restarts Dock/Finder/ControlCenter/SystemUIServer/mds
│   │   ├── organizeHome.sh   # Home directory layout
│   │   ├── cli.sh            # CLI Homebrew formulas
│   │   ├── media.sh          # Media casks
│   │   ├── productivity.sh   # Productivity casks
│   │   ├── dev.sh            # Development tooling
│   │   ├── security.sh       # Security tooling
│   │   ├── shell.sh          # Shell / terminal setup (zsh)
│   │   └── post-install.sh   # Final steps
│   ├── dotfiles/
│   └── assets/
├── setup_errors.log          # Created at repo root when scripts run (gitignored)
└── LICENSE
```

## Execution flow (`master.sh`)

1. `pre-install.sh` — Homebrew, Xcode Command Line Tools, system updates
2. `system-config.sh` — macOS preferences and security-related system settings
3. `organizeHome.sh` — home directory organization
4. `cli.sh`, `media.sh`, `productivity.sh` — Homebrew formulas and casks
5. `dev.sh` — development stack
6. `security.sh` — security tools and related setup
7. `shell.sh` — zsh and related configuration
8. `post-install.sh` — cleanup and completion

## `system-config.sh` (macOS defaults)

This script writes user and system preferences and ends by restarting **Dock**, **Finder**, **ControlCenter**, **SystemUIServer**, and **mds** so changes take effect. Highlights:

- **Appearance & UI**: Dark mode, small sidebar icons, reduced window animation for snappier feedback
- **Input**: Classic scrolling, fast key repeat, full keyboard access (Tab through all controls), three-finger drag
- **Security (single `sudo` session)**: Application Firewall on, stealth mode, guest account off, automatic macOS updates via `/Library/Preferences/com.apple.SoftwareUpdate`, plus `pmset` options suited to Apple Silicon (lid wake, TCP keepalive, Power Nap)
- **Hardening & updates**: `.DS_Store` suppression on network/USB volumes, security-related Software Update toggles, Launch Services quarantine prompt off, Crash Reporter dialog off, disk “not ejected properly” notification off, screen-lock password settings
- **Finder & screenshots**: Show extensions and hidden files, path bar, column view, search scoped to the current folder, POSIX path in the title bar, spring-loading for folders, screenshots under `~/Pictures/Screenshots` (directory created before setting the path)
- **Dock & Spotlight**: Autohide, minimize into app icon, no recent apps, faster Dock animations; Spotlight category ordering
- **Menu bar**: Custom clock format; battery percentage hidden (`com.apple.menuextra.battery` and `com.apple.controlcenter` for newer Control Center behavior)
- **Night Shift**: Enabled with sunset–sunrise-style schedule (strength and schedule keys as in the script)

Adjust `system-config.sh` if you prefer stricter security (for example keeping quarantine prompts) or different power-management values.

## Helpers (`utils.sh`)

- `log_error` — stderr plus append to `setup_errors.log`
- `ensure_directory` — `mkdir -p` with errors logged
- `copy_file_safe` / `copy_directory_safe` — copy only when source exists and destination is missing
- `download_file_safe` — `curl` with timeouts and validation

Scripts append command errors with `2>>"$ERROR_LOG_FILE" || true` where appropriate so a single failure does not stop the whole run.

## Logging

- **Error log**: `setup_errors.log` at the repository root (see `ERROR_LOG_FILE` in `utils.sh`). The file is gitignored (`*.log`).

## Testing

On push/PR to `master`, **Test Runner** (`.github/workflows/test-runner.yaml`) runs the scripts on a GitHub-hosted macOS runner. `pre-install.sh` is skipped there to avoid long Xcode/OS update steps; the workflow checks `setup_errors.log` for real failures.

## What gets installed

Illustrative list; see each `*.sh` for the exact Homebrew lines.

### System configuration

- Homebrew and Xcode Command Line Tools (via `pre-install.sh`)
- Firewall, stealth mode, guest account, Software Update and `pmset` behavior (via `system-config.sh`)

### Development, CLI, media, productivity, security

Examples include Node/Python tooling, Docker-related tooling, editors, browsers, media apps, and security casks and repositories—aligned with `dev.sh`, `cli.sh`, `media.sh`, and `security.sh`.

**Productivity** (`productivity.sh`): Homebrew casks for Balena Etcher, Notion, Proton Drive, Proton Mail, Standard Notes, and Zoom; plus the Raycast formula.

### Configuration files

Dotfiles and assets under `src/dotfiles/` and `src/assets/` as copied or referenced by the scripts.

## Troubleshooting

- **Permissions**: Some steps need `sudo`; you may be prompted once per `sudo` invocation (grouped in `system-config.sh` where possible).
- **Homebrew**: `pre-install.sh` expects to install or use Homebrew if missing.
- **Logs**: Inspect `setup_errors.log` at the repo root after a run.

```bash
tail -n 50 setup_errors.log
```

## Customization

- **New Homebrew items**: Add formulas or casks to the appropriate script arrays or `brew install` lines.
- **Dotfiles**: Edit files under `src/dotfiles/` and re-run the relevant script or `master.sh`.

## Maintainers

[@garretpatten](https://github.com/garretpatten/)

For questions, bug reports, or feature requests, open an issue on this repository.

## License

This project is licensed under the [MIT License](./LICENSE).
