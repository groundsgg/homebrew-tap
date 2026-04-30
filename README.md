# homebrew-tap

Homebrew tap for Grounds CLI.

## Install and upgrade

Standard tap commands:

```bash
brew install groundsgg/tap/grounds
brew upgrade groundsgg/tap/grounds
brew info groundsgg/tap/grounds
```

Local file install (for maintainers):

```bash
brew install ./grounds.rb
```

## Repository layout

- `grounds.rb`: Homebrew formula for Linux/macOS package installation.
- `scripts/validate_tap.sh`: consistency checks for formula metadata.

## Local validation

Run the tap consistency validation:

```bash
./scripts/validate_tap.sh
```

Optional Homebrew audits:

```bash
brew audit --strict --formula ./grounds.rb
```
