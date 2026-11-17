# Security Policy

This is a personal Neovim configuration. Only the latest commit on the default branch is supported.

## Reporting a vulnerability

Please do not open a public issue. Use GitHub's private reporting:
**Security → Report a vulnerability** on https://github.com/charlyraffellini/config.nvim
(or contact the maintainer via GitHub if that is unavailable).

You can expect an initial response within a few days.

## Scope and notes

- Plugins, Mason LSP servers and Treesitter parsers are third-party code run with your user's privileges; vulnerabilities in them should be reported upstream.
- Never commit secrets (`.env` files, tokens). `cloak.nvim` only masks values on screen.
- If a secret is committed, revoke it immediately, then remove it from history.
