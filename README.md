# config.nvim

Personal Neovim configuration (Lua, Packer-based) by [@charlyraffellini](https://github.com/charlyraffellini).
It provides LSP (lsp-zero + Mason), completion (nvim-cmp), Telescope, Treesitter, Harpoon, Undotree, Fugitive, Bufferline/Lualine, Scala (nvim-metals), GitHub Copilot, secret cloaking and autosave.

- Leader key: `<Space>`
- Own modules live in `lua/elrafa/`, per-plugin settings in `after/plugin/`
- Extra notes: [`docs/`](docs/) (shortcuts, plugin reinstall, autosave, Mason fix, bufferline icons)

## Requirements

| Tool | Why |
|------|-----|
| Neovim >= 0.9 (developed on 0.12) | Core |
| `git` | Packer and plugins are cloned with it |
| A C compiler (`clang`/`gcc`) | Treesitter parser builds |
| `node` + `npm` | Mason-installed `ts_ls`, Copilot |
| `python3` | `pyright` |
| `ripgrep` (`rg`) (+ optionally `fd`) | Telescope live grep |
| A [Nerd Font](https://github.com/ryanoasis/nerd-fonts), set as terminal font | Bufferline/Lualine icons |
| Optional: JDK + `coursier` | Scala / nvim-metals |

macOS example:

```bash
brew install neovim git node python ripgrep fd
brew install --cask font-jetbrains-mono-nerd-font   # or any Nerd Font
```

## Install

> Back up any existing config first: `mv ~/.config/nvim ~/.config/nvim.bak`

```bash
# 1. Clone the config
git clone https://github.com/charlyraffellini/config.nvim ~/.config/nvim

# 2. Install Packer (plugin manager)
git clone --depth 1 https://github.com/wbthomason/packer.nvim \
  ~/.local/share/nvim/site/pack/packer/start/packer.nvim

# 3. Install vim-plug (used by init.lua for a few extra plugins)
curl -fLo ~/.local/share/nvim/site/autoload/plug.vim --create-dirs \
  https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim

# 4. Install all plugins
nvim --headless -c 'autocmd User PackerComplete quitall' -c 'PackerSync'
```

Then open `nvim` and run:

- `:PlugInstall` – installs vim-visual-multi, popfix, nvim-lsputils
- `:Mason` – check LSP servers (`ts_ls`, `pyright` are requested in `after/plugin/lsp.lua`)
- `:TSUpdate` – Treesitter parsers
- `:Copilot setup` – authenticate GitHub Copilot (needs a Copilot subscription)
- `:checkhealth` – verify everything

The first start may show errors until plugins are installed; restart nvim after `PackerSync`.

## Using it

| Key | Action |
|-----|--------|
| `<leader>pv` | File explorer (netrw) |
| `<leader>pf` / `<leader>ps` | Telescope: find files / grep |
| `<leader>as` | Toggle autosave (on by default) |
| `<leader>y` / `<leader>p` | System clipboard yank / paste without clobbering register |

Full list: [docs/custom-shortcuts.md](docs/custom-shortcuts.md).
Behaviours to know: trailing whitespace is stripped on every save, and autosave writes on `InsertLeave`/`TextChanged`.

## Update

```bash
cd ~/.config/nvim && git pull --ff-only
nvim --headless -c 'autocmd User PackerComplete quitall' -c 'PackerSync'
```

- `:PackerSync` updates plugins (edit `lua/elrafa/packer.lua` to add/remove them); `:PlugUpdate` for vim-plug ones; `:MasonUpdate` for LSP servers; `:TSUpdate` for parsers.
- If plugins break, follow [docs/20260116-plugin-cleanup-and-install.md](docs/20260116-plugin-cleanup-and-install.md) to wipe and reinstall.
- `plugin/packer_compiled.lua` and `plugged/` are git-ignored and regenerated.
- Plugins track their default branch (most are unpinned); to reproduce a known-good state, pin with `tag`/`commit` in `packer.lua`.

## Security

- **Third-party code**: all plugins, Mason LSP servers and Treesitter parsers are downloaded and executed with your user's privileges. Review additions to `packer.lua` and prefer pinned tags/commits.
- **Secrets**: `cloak.nvim` masks values after `=` in `.env`-style files on screen only; it does not encrypt anything. Never commit `.env` files or tokens to this repo.
- **Copilot**: `github/copilot.vim` sends surrounding code/context to GitHub. Disable per-session with `:Copilot disable`, or avoid it on confidential repos (`let g:copilot_filetypes = {...}`) .
- **Modelines/projects**: be careful opening untrusted projects (project-local configs, LSP servers such as metals run code from the project).
- **Rollback**: `~/.config/nvim` is a git repo; use `git log`/`git revert` to undo a bad update.
- Report security issues privately, see [SECURITY.md](SECURITY.md).

## Tests

Specs live in `test/` and run with [plenary](https://github.com/nvim-lua/plenary.nvim) (installed by Packer):

```bash
nvim --headless -u NONE \
  -c "set rtp+=~/.config/nvim,~/.local/share/nvim/site/pack/packer/start/plenary.nvim" \
  -c "PlenaryBustedDirectory test"
```

## License

[MIT](LICENSE). Security policy: [SECURITY.md](SECURITY.md).
