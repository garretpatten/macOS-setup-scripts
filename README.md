<!-- markdownlint-disable MD033 MD041 -->

<p align="center">
    <img src="https://img.shields.io/badge/macOS%20setup-scripts-000000?style=for-the-badge&logo=apple&logoColor=white&labelColor=1d1d1f" alt="Apple-style badge: macOS setup scripts project" />
  </a>
</p>

<h1 align="center">macOS Setup Scripts</h1>

<p align="center"><strong>Bash automation for a development-ready Mac.</strong></p>

<p align="center">
Homebrew installs, shell and Terminal setup, optional dotfiles, and opinionated<br />
<code style="padding: 0.15rem 0.4rem;">defaults write</code> tuning for Apple Silicon and Intel.
</p>

<p align="center">
  <a href="./LICENSE"><img src="https://img.shields.io/github/license/garretpatten/macOS-setup-scripts?style=flat-square" alt="License" /></a>
  <img src="https://img.shields.io/badge/platform-macOS-0071e3?style=flat-square&logo=apple&logoColor=white" alt="Runs on macOS" />
</p>

<!-- markdownlint-enable MD033 MD041 -->

---

## Overview

Structured automation for provisioning a polished, development-focused macOS environment:
Homebrew formulas and casks, system-wide defaults, and repeatability you can trust in CI.

## Features

- **Install vs configuration**: Category scripts are split under `src/scripts/install/` (Homebrew, installers, clones) and `src/scripts/config/` (`defaults write`, dotfiles, Git identity, login shell). Orchestrators run one bundle or both.
- **npm entrypoints**: After `npm ci`, use `npm run installs`, `npm run config`, or `npm run all` (see [npm scripts](#npm-scripts)).
- **Shared helpers**: `utils.sh` centralizes repo paths, `log_error`, safe copy/download helpers, and a single error log path.
- **System defaults**: `config/system-config.sh` applies appearance, input, Finder, Dock, Spotlight, menu bar (clock/battery), Night Shift, security-related settings, and Apple Silicon–friendly `pmset` tuning (see below).
- **CI**: GitHub Actions runs `master.sh --ci` on `macos-latest` (skips `install/pre-install.sh` for speed).

## Quick start

### Prerequisites

- macOS (recent versions; scripts assume Darwin)
- Network access for Homebrew and downloads
- Administrator privileges when `sudo` is required (for example firewall, guest account, system Software Update plist, and `pmset` in `config/system-config.sh`)

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

3. **Install Node dev deps** (needed for `npm run`)

   ```bash
   npm ci
   ```

4. **Make scripts executable**

   ```bash
   chmod +x src/scripts/*.sh \
     src/scripts/install/*.sh \
     src/scripts/config/*.sh
   ```

5. **Run setup**

   ```bash
   npm run all
   # or: bash src/scripts/master.sh
   ```

### npm scripts

| Command            | Runs                                                                                                                                                                       |
| ------------------ | -------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| `npm run all`      | Full provisioning (`master.sh`): interleaved installs and configuration (same order as the historical single `master.sh`; see [Execution flow](#execution-flow-mastersh)). |
| `npm run installs` | Install bundle only (`run-install.sh`): Homebrew, external installers, and security repo clones—no `defaults write` or dotfiles.                                           |
| `npm run config`   | Configuration bundle only (`run-config.sh`): macOS defaults, home layout, dev/shell dotfiles, Proton Pass `PATH` hook, completion banner.                                  |

Use **`npm run config`** on machines that already have packages but should pick up the latest `defaults`, dotfiles copies, or shell tweaks from this repo.

Bash equivalents:

```bash
bash src/scripts/run-install.sh
bash src/scripts/run-config.sh
bash src/scripts/master.sh
```

### Granular scripts

Run a single category (paths are relative to the repo root):

```bash
bash src/scripts/install/cli.sh
bash src/scripts/config/system-config.sh    # macOS defaults only
bash src/scripts/config/organizeHome.sh
```

`config/shell.sh` is normally invoked by `run-config.sh` / `master.sh` with **`zsh`** (login-shell parity with the prior setup).

## Project structure

```text
macOS-setup-scripts/
├── .github/workflows/
│   └── test-runner.yaml      # CI: master.sh --ci on macOS runners
├── src/
│   ├── scripts/
│   │   ├── utils.sh           # Paths, logging, safe copy/download helpers
│   │   ├── master.sh          # Full run: installs + config (interleaved; see below)
│   │   ├── run-install.sh     # Install bundle only (--ci skips pre-install)
│   │   ├── run-config.sh      # Configuration bundle only
│   │   ├── install/
│   │   │   ├── pre-install.sh # Homebrew bootstrap, Xcode CLT, softwareupdate
│   │   │   ├── cli.sh         # CLI formulas
│   │   │   ├── media.sh       # Media casks
│   │   │   ├── productivity.sh
│   │   │   ├── dev.sh         # Dev formulas/casks, NVM, packer.nvim
│   │   │   ├── security.sh    # Security packages, Proton Pass installer, clones
│   │   │   ├── shell.sh       # Terminal fonts, Ghostty, tmux, Oh My Posh, etc.
│   │   │   └── post-install.sh# brew update / upgrade / cleanup
│   │   └── config/
│   │       ├── system-config.sh  # defaults write, firewall, pmset; restarts services
│   │       ├── organizeHome.sh   # Home directory layout
│   │       ├── dev.sh            # Dotfiles (editors), global git config, colima start
│   │       ├── shell.sh          # Shell/tmux dotfiles, ~/.dotfiles_path, chsh
│   │       ├── security.sh       # Proton Pass PATH snippet in ~/.zshrc
│   │       └── completion.sh     # Banner + next steps
│   ├── dotfiles/              # Submodule
│   └── assets/                # Completion banner (e.g. apple.txt)
├── setup_errors.log           # Created at repo root when scripts run (gitignored)
└── LICENSE
```

## Execution flow (`master.sh`)

`master.sh` keeps the historical **interleaved** ordering so macOS preferences run before long Homebrew work, development dotfiles apply immediately after dev packages, and shell dotfiles run after `install/post-install.sh`:

1. `install/pre-install.sh` — Homebrew bootstrap, Xcode Command Line Tools, `softwareupdate` (skipped with `master.sh --ci`)
2. `config/system-config.sh` — macOS preferences and security-related system settings
3. `config/organizeHome.sh` — home directory layout
4. `install/cli.sh`, `install/media.sh`, `install/productivity.sh` — category installs
5. `install/dev.sh` — development Homebrew stack, NVM, `packer.nvim`
6. `config/dev.sh` — editor/Neovim dotfiles, global Git settings, `colima start`
7. `install/security.sh` — security packages, Proton Pass installer, `~/Hacking` clones
8. `install/shell.sh` — shell/terminal Homebrew packages
9. `install/post-install.sh` — `brew` maintenance
10. `config/shell.sh` — shell/dotfiles and default login shell (via **`zsh`**)
11. `config/security.sh` — append Proton Pass `PATH` to `~/.zshrc` if missing
12. `config/completion.sh` — completion banner

**`run-install.sh`** runs steps **1** (optional) and **4–9** only (no `defaults` or dotfiles). **`run-config.sh`** runs **2**, **3**, **6**, **10–12** in order (full configuration pass without installing packages).

## `config/system-config.sh` (macOS defaults)

This script writes user and system preferences and ends by restarting **Dock**, **Finder**, **ControlCenter**, **SystemUIServer**, and **mds** so changes take effect. Highlights:

- **Appearance & UI**: Dark mode, small sidebar icons, reduced window animation for snappier feedback
- **Input**: Classic scrolling, fast key repeat, full keyboard access (Tab through all controls), three-finger drag
- **Security (single `sudo` session)**: Application Firewall on, stealth mode, guest account off, automatic macOS updates via `/Library/Preferences/com.apple.SoftwareUpdate`, plus `pmset` options suited to Apple Silicon (lid wake, TCP keepalive, Power Nap)
- **Hardening & updates**: `.DS_Store` suppression on network/USB volumes, security-related Software Update toggles, Launch Services quarantine prompt off, Crash Reporter dialog off, disk “not ejected properly” notification off, screen-lock password settings
- **Finder & screenshots**: Show extensions and hidden files, path bar, column view, search scoped to the current folder, POSIX path in the title bar, spring-loading for folders, screenshots under `~/Pictures/Screenshots` (directory created before setting the path)
- **Dock & Spotlight**: Autohide, minimize into app icon, no recent apps, faster Dock animations; Spotlight category ordering
- **Menu bar**: Custom clock format; battery percentage hidden (`com.apple.menuextra.battery` and `com.apple.controlcenter` for newer Control Center behavior)
- **Night Shift**: Enabled with sunset–sunrise-style schedule (strength and schedule keys as in the script)

Adjust `config/system-config.sh` if you prefer stricter security (for example keeping quarantine prompts) or different power-management values.

## Helpers (`utils.sh`)

- `log_error` — stderr plus append to `setup_errors.log`
- `ensure_directory` — `mkdir -p` with errors logged
- `copy_file_safe` / `copy_directory_safe` — copy only when source exists and destination is missing
- `download_file_safe` — `curl` with timeouts and validation

Scripts append command errors with `2>>"$ERROR_LOG_FILE" || true` where appropriate so a single failure does not stop the whole run.

## Logging

- **Error log**: `setup_errors.log` at the repository root (see `ERROR_LOG_FILE` in `utils.sh`). The file is gitignored (`*.log`).

## Testing

On push/PR to `master`, **Test Runner** (`.github/workflows/test-runner.yaml`) runs `bash src/scripts/master.sh --ci` on a GitHub-hosted macOS runner. That skips `install/pre-install.sh` to avoid long Xcode/OS update steps; the workflow checks `setup_errors.log` for real failures.

## What gets installed and configured

Illustrative list; see each script under `src/scripts/install/` and `src/scripts/config/` for exact commands.

### Install bundle (`install/`)

#### Pre-install (`install/pre-install.sh`)

- Homebrew (install if missing), `brew update`, `brew upgrade`, `brew cleanup`, analytics off
- Xcode Command Line Tools and system software updates (`softwareupdate`)

#### CLI tools (`install/cli.sh`)

bat, btop, curl, eza, fastfetch, fd, git, htop, jq, lazygit, ripgrep, vim, wget

#### Media (`install/media.sh`)

Brave Browser, DuckDuckGo, Spotify, VLC

#### Productivity (`install/productivity.sh`)

- **Homebrew casks**: Balena Etcher, Google Gemini (desktop), Notion, Proton Drive, Proton Mail, Standard Notes, Zoom
- **Homebrew formula**: Raycast

#### Development (`install/dev.sh`)

- **Homebrew formulas**: Node, Python 3.12, Colima, Docker, Docker Compose, GitHub CLI (`gh`), Neovim, Podman, Semgrep, ShellCheck, Tree-sitter, Angular CLI
- **Homebrew casks**: Postman, Visual Studio Code
- **Other Homebrew**: Sourcegraph app (from `sourcegraph/app` tap), Sourcegraph CLI (`src-cli`)
- **Also**: NVM (official install script), `packer.nvim` clone for Neovim

#### Security (`install/security.sh`)

- **Homebrew casks**: 1Password, 1Password CLI, Proton VPN, Signal, Burp Suite, OWASP ZAP
- **Homebrew formulas**: OpenVPN, ExifTool, Nmap
- **Also**: Proton Pass CLI (install script), clones **PayloadsAllTheThings** and **SecLists** into `~/Hacking/` (directory created if needed)

#### Shell and terminal (`install/shell.sh`)

- **Homebrew formulas**: Oh My Posh (`jandedobbeleer/oh-my-posh/oh-my-posh`), Ghostty, Zsh, tmux, zsh-autosuggestions, zsh-syntax-highlighting
- **Homebrew casks**: Font Awesome Terminal Fonts, Fira Code, Meslo LG Nerd Font, Powerline Symbols

#### Post-install (`install/post-install.sh`)

`brew` update, upgrade, and cleanup

### Configuration bundle (`config/`)

#### System defaults (`config/system-config.sh`)

- Firewall, stealth mode, guest account, Software Update and `pmset` behavior (no Homebrew packages)

#### Home layout (`config/organizeHome.sh`)

Creates `~/Books`, `~/Games`, `~/Hacking`, `~/Projects`; removes empty `~/Templates` if present

#### Development (`config/dev.sh`)

Optional Neovim / Vim / VS Code / terminal-app config from `src/dotfiles/`, global Git user settings and credential helper, `colima start`

#### Shell and terminal (`config/shell.sh`)

- **Also**: Ghostty and Oh My Posh config trees, **`~/.config/tmux/`** (modular tmux includes/themes), `.zshrc`, `.tmux.conf` from `src/dotfiles/`; writes **`~/.dotfiles_path`** when missing or stale; default login shell set to Zsh

#### Security (`config/security.sh`)

Appends **`export PATH="/Users/garret/.local/bin:$PATH"`** to `~/.zshrc` when Proton Pass CLI’s bin is not already referenced (runs after `config/shell.sh` so the main `~/.zshrc` is copied first).

#### Completion (`config/completion.sh`)

Prints completion notes and `src/assets/apple.txt` when present ([Fastfetch macOS ASCII logo](https://github.com/fastfetch-cli/fastfetch/blob/dev/src/logo/ascii/macos.txt), with color placeholders removed for plain `cat` output)

### Assets

Dotfiles and assets under `src/dotfiles/` and `src/assets/` as copied or referenced by the configuration scripts.

## Troubleshooting

- **Permissions**: Some steps need `sudo`; you may be prompted once per `sudo` invocation (grouped in `config/system-config.sh` where possible).
- **Homebrew**: `install/pre-install.sh` expects to install or use Homebrew if missing.
- **Logs**: Inspect `setup_errors.log` at the repo root after a run.

```bash
tail -n 50 setup_errors.log
```

## Customization

- **New Homebrew items**: Add formulas or casks to the matching file under `src/scripts/install/`, then run `npm run installs` (or `bash src/scripts/run-install.sh`) or the single category script.
- **macOS defaults or dotfiles**: Develop changes in the [dotfiles](https://github.com/garretpatten/dotfiles) repository when editing the submodule; bump this repo’s **`src/dotfiles`** submodule to that commit. Edit `src/scripts/config/` for provisioning tweaks. Run **`npm run config`** / **`bash src/scripts/run-config.sh`** (or `master.sh`) to apply configuration without reinstalling packages.

## Dotfiles integration notes

- **`~/.dotfiles_path`**: `config/shell.sh` seeds or refreshes this file so `home/.zshrc` can find the checkout (for example **`…/macOS-setup-scripts/src/dotfiles`**).
- **tmux**: The vendored **`home/.tmux.conf`** expects **`~/.config/tmux/`** (includes, themes). `config/shell.sh` copies **`src/dotfiles/config/tmux/`** when that destination is not already present.
- **Full XDG symlink mirror**: To link every **`config/<app>/`** tree under **`~/.config/<app>/`**, run **`./setup.sh --link-xdg-config`** from the submodule directory (see the [dotfiles README](https://github.com/garretpatten/dotfiles/blob/master/README.md)). Parent **`config/`** scripts still copy a **subset** for the apps this repo provisions (`config/dev.sh`, `config/shell.sh`).
- **Upstream workflow**: After updating the submodule, run **`npm run config`** (or `master.sh`) to consume changes on this machine.

## Maintainers

[@garretpatten](https://github.com/garretpatten/)

For questions, bug reports, or feature requests, open an issue on this repository.

## License

This project is licensed under the [MIT License](./LICENSE).
