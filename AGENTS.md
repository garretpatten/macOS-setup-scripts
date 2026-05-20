# AGENTS.md

Guidance for coding agents working in **macOS-setup-scripts**.

## Repository summary

- Bash automation for provisioning a development-focused macOS environment (Homebrew, dotfiles, `defaults write`, and related setup).
- **Orchestrators**: `src/scripts/master.sh` (full run, **interleaved** install + config order), `src/scripts/run-install.sh` (packages only), `src/scripts/run-config.sh` (`defaults`, dotfiles, shell hooks). **npm**: `npm run all` / `installs` / `config` (see `package.json` and `README.md`).
- **Shared helpers**: `src/scripts/utils.sh` — defines `SCRIPTS_DIR` (always `src/scripts/`), `PROJECT_ROOT`, and `ERROR_LOG_FILE`.
- Dotfiles live in the `src/dotfiles/` git submodule (do not edit unless the task explicitly requires submodule changes). **`install/*.sh`** copies/installs packages; **`config/*.sh`** applies `defaults`, copies submodule trees into `~`, Git identity, `chsh`, etc. When submodule `home/` or `config/` gains new required paths, update the matching **`config/`** script (or document **`setup.sh --link-xdg-config`** in the dotfiles repo).
- User-facing docs: `README.md`.
- CI on pull requests:
  - **Quality Checks** (`.github/workflows/quality-checks.yaml`) — markdownlint, Prettier, ShellCheck, yamllint via [garretpatten/quality-checks](https://github.com/garretpatten/quality-checks).
  - **Test Runner** (`.github/workflows/test-runner.yaml`) — runs `bash src/scripts/master.sh --ci` on `macos-latest` (skips `install/pre-install.sh`).

## Layout

```text
src/scripts/
  utils.sh, master.sh, run-install.sh, run-config.sh
  install/            # Homebrew, external installers, clones (per category)
  config/             # defaults write, dotfiles, shell/security tweaks, completion banner
src/dotfiles/         # Submodule — separate repo; excluded from root Prettier runs
src/assets/           # Static assets (e.g. apple.txt)
.github/workflows/    # GitHub Actions
```

## Shell script conventions

- Use `#!/bin/bash` and `set` behavior consistent with neighboring scripts.
- Source shared code with a ShellCheck hint. Scripts in **`install/`** or **`config/`**:

  ```bash
  # shellcheck source=../utils.sh
  source "$(dirname "$0")/../utils.sh"
  ```

  Top-level scripts next to **`utils.sh`** may use `# shellcheck source=utils.sh` and `source "$(dirname "$0")/utils.sh"`.

- Prefer `utils.sh` helpers (`log_error`, `ensure_directory`, `copy_file_safe`, and so on) over duplicating logic.
- Append recoverable command failures with `2>>"$ERROR_LOG_FILE" || true` where other scripts already do.
- Keep changes scoped to the requested task; avoid unrelated refactors or drive-by formatting outside touched files.

## Linter configuration

| Tool              | Config                                      | Notes                                            |
| ----------------- | ------------------------------------------- | ------------------------------------------------ |
| markdownlint-cli2 | `.markdownlint.yaml`, `.markdownlintignore` | MD013 (line length) is off                       |
| Prettier          | `.prettierrc`, `.prettierignore`            | `src/dotfiles/` is ignored at repo root          |
| ShellCheck        | `.shellcheckrc`                             | `external-sources=true`, `source-path=SCRIPTDIR` |
| yamllint          | `.yamllint`                                 | Line length max 80; `document-start` disabled    |

## Required quality gate

**Before you finalize any change** (end of task, commit, or PR), you **must** run all four linters below on every file you added or modified (and on any new files you created). Do not skip this step.

1. Fix reported issues (use auto-fix flags where noted).
2. Re-run checks until all four pass.
3. In your final message, state that the four linters passed or list anything you could not run and why.

If a tool is missing locally, install it (see [Prerequisites](#prerequisites)) or use the `npx` / `pip3` invocations below. Do not mark work complete while known lint failures remain in changed paths.

## Prerequisites

From the repository root:

```bash
npm ci
```

Install CLI tools if needed (macOS examples):

```bash
brew install shellcheck
pip3 install yamllint
npm install -g markdownlint-cli2   # optional; npx works without global install
```

Prettier is provided by this repo’s `package.json` after `npm ci`.

## Running linters

Run commands from the **repository root** so config files are discovered.

### Changed files only (typical)

Set a diff base (adjust branch name if needed):

```bash
BASE_REF="${BASE_REF:-origin/master}"
git fetch origin master 2>/dev/null || true
```

Collect paths you changed:

```bash
mapfile -t MD_FILES < <(git diff --name-only --diff-filter=ACMR "${BASE_REF}"...HEAD | grep -E '\.(md|markdown)$' || true)
mapfile -t SH_FILES < <(git diff --name-only --diff-filter=ACMR "${BASE_REF}"...HEAD | grep -E '\.(sh|bash|zsh)$' || true)
mapfile -t YAML_FILES < <(git diff --name-only --diff-filter=ACMR "${BASE_REF}"...HEAD | grep -E '\.(yml|yaml)$' || true)
mapfile -t PRETTIER_FILES < <(git diff --name-only --diff-filter=ACMR "${BASE_REF}"...HEAD | grep -E '\.(js|jsx|ts|tsx|json|css|scss|md|yml|yaml)$' || true)
```

Then run (skip a tool when its file list is empty):

```bash
# markdownlint — check
[[ ${#MD_FILES[@]} -gt 0 ]] && markdownlint-cli2 "${MD_FILES[@]}"

# markdownlint — fix, then re-check
[[ ${#MD_FILES[@]} -gt 0 ]] && markdownlint-cli2 --fix "${MD_FILES[@]}"

# Prettier — check (matches CI)
[[ ${#PRETTIER_FILES[@]} -gt 0 ]] && npx prettier --no-error-on-unmatched-pattern --check "${PRETTIER_FILES[@]}"

# Prettier — write, then re-check
[[ ${#PRETTIER_FILES[@]} -gt 0 ]] && npx prettier --no-error-on-unmatched-pattern --write "${PRETTIER_FILES[@]}"

# ShellCheck
[[ ${#SH_FILES[@]} -gt 0 ]] && shellcheck "${SH_FILES[@]}"

# yamllint
[[ ${#YAML_FILES[@]} -gt 0 ]] && yamllint "${YAML_FILES[@]}"
```

Without a global `markdownlint-cli2`:

```bash
npx --yes markdownlint-cli2 "${MD_FILES[@]}"
npx --yes markdownlint-cli2 --fix "${MD_FILES[@]}"
```

### Full-repo checks (when unsure what changed)

Use when you touched many paths or want parity with a broad local sweep:

```bash
npx --yes markdownlint-cli2 "**/*.md"
npx prettier --no-error-on-unmatched-pattern --check .
shellcheck src/scripts/utils.sh \
  src/scripts/master.sh \
  src/scripts/run-install.sh \
  src/scripts/run-config.sh \
  src/scripts/install/*.sh \
  src/scripts/config/*.sh
yamllint .github .yamllint .markdownlint.yaml
```

Prettier honors `.prettierignore` (including `src/dotfiles/`). Yamllint loads `.yamllint` from the current directory.

## Typical validation order

1. **Shell** (`utils.sh`, orchestrators, `install/*.sh`, `config/*.sh`): `shellcheck`
2. **YAML** (`.github/`, root `*.yaml` / `*.yml`): `yamllint`
3. **Markdown**: `markdownlint-cli2` (fix with `--fix` if needed)
4. **Prettier** (JSON, Markdown, YAML, and other supported types in scope): `prettier --check` after any `--write`

## Before finishing (checklist)

- [ ] `markdownlint-cli2` passed on all changed Markdown files
- [ ] `npx prettier --check` passed on all changed files Prettier handles (respecting `.prettierignore`)
- [ ] `shellcheck` passed on all changed shell scripts
- [ ] `yamllint` passed on all changed YAML files
- [ ] No unrelated files were reformatted or lint-fixed outside the task scope
- [ ] If a linter could not be run, that fact is called out explicitly in the summary

## Commits and pull requests

- Create commits only when the user asks.
- Pull requests are validated by **Quality Checks** and **Test Runner**; local runs above should match CI behavior for the four linters.
- Do not modify `src/dotfiles/` unless the task requires it; submodule changes have their own workflow in that repository.
