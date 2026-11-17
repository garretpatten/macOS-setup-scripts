# Contributing

Participants are expected to follow the [Code of Conduct](./CODE_OF_CONDUCT.md).

## Issues

Security vulnerabilities are **not** tracked in public issues until addressed; see **[SECURITY.md](./SECURITY.md)**.

Use [GitHub Issues](https://github.com/garretpatten/macOS-setup-scripts/issues) with the **Bug report** or **Feature request** form. Include macOS version (`sw_vers`), Apple Silicon vs Intel, commands run, and relevant lines from **`setup_errors.log`** (redact private paths).

## Pull requests

- Branch from **`master`**, focused scope per PR.
- Keep installs idempotent (skip work if Homebrew packages, dirs, or targets already satisfy the goal).
- **Dotfiles submodule**: substantive configs belong upstream in **`src/dotfiles`** unless the provisioning scripts own one-off machine behavior — submodule bumps must be explicit. Never edit files inside `src/dotfiles/` directly in this repository.

### Checks (from repo root)

```bash
npm ci

npx prettier --no-error-on-unmatched-pattern --check .
npx --yes markdownlint-cli2 "**/*.md"
shellcheck src/scripts/utils.sh \
  src/scripts/master.sh \
  src/scripts/run-install.sh \
  src/scripts/run-config.sh \
  src/scripts/install/*.sh \
  src/scripts/config/*.sh \
  tests/*.bats tests/helpers/*.bash tests/stubs/* tests/fixtures/*.sh
yamllint .github .yamllint .markdownlint.yaml
bats tests/
```

**Quality Checks** CI runs markdownlint, Prettier, ShellCheck, and yamllint. **Test Runner** CI runs ShellCheck on `tests/` plus `bats tests/` on `ubuntu-latest`, and `bash src/scripts/master.sh --ci` on `macos-latest` (skips `install/pre-install.sh`).

Documentation and template changes still need a clean **Prettier**, **markdownlint**, and **yamllint** run. When you change shell scripts or tests, also run **ShellCheck** and **`bats tests/`**. See [`AGENTS.md`](./AGENTS.md) for details.

Keep YAML within **`.yamllint`** (80-character lines unless an existing waiver applies).
