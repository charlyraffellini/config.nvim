# 2025-01-16 — Mason / LSP / Bufferline fixes

Summary
-------
Notes collected from fixes applied to the Neovim configuration to resolve:
- bufferline "Segments must be a list" error,
- mason / mason-lspconfig ensure_installed issues,
- lsp-zero / nvim-lspconfig deprecation on Nvim 0.11+,
- general robust startup sequencing for LSP.

Files changed
-------------
- after/plugin/bufferline.lua
  - Fixed get_element_icon to safely call nvim-web-devicons and always return the expected (icon, hl) pair or nil safely.

- after/plugin/lsp.lua
  - Replaced brittle LSP setup with a defensive safe_setup_lsp:
    - pcall wrappers around lsp-zero, mason, mason-lspconfig
    - call mason.setup() before using mason-lspconfig
    - filter ensure_installed using mason-lspconfig.get_available_servers()
    - alias map for legacy names (example: "tsserver" -> "ts_ls")
    - run lsp-zero setup guarded in pcall
    - schedule setup via autocommands (VimEnter and User PackerComplete)

- lua/elrafa/packer.lua
  - Ensure lsp-zero and nvim-lspconfig are not pinned to old commits (use current releases).

- docs/20250116-fixing-bufferline-icons.md
  - Documented the bufferline icon fix and testing steps.

What was changed (concise)
--------------------------
1. Bufferline icon fix (after/plugin/bufferline.lua)
   - Use pcall(require, "nvim-web-devicons")
   - Compute filename with vim.fn.fnamemodify(element.path, ":t")
   - Call webdev_icons.get_icon(name, element.extension, { default = true })
   - Return icon, hl (or nil when icons missing) so bufferline receives valid segments.

2. Defensive LSP boot (after/plugin/lsp.lua)
   - Ensure mason.nvim is setup before mason-lspconfig calls.
   - Build ensure_installed list only from names that appear in mason-lspconfig.get_available_servers().
   - Map legacy aliases (tsserver → ts_ls) if needed.
   - Run lsp-zero setup only after plugins are loaded (VimEnter / PackerComplete autocmds).
   - Wrap external calls in pcall to prevent hard failures during packer operations.

3. Plugin updates
   - Unpin or update lsp-zero and nvim-lspconfig to versions compatible with Neovim 0.11+.
   - If necessary, remove plugin folders and reinstall via Packer to ensure latest commits:
     - rm -rf ~/.local/share/nvim/site/pack/packer/start/nvim-lspconfig
     - rm -rf ~/.local/share/nvim/site/pack/packer/start/lsp-zero.nvim
     - Then run PackerSync.

Commands used and recommended
-----------------------------
- Upgrade Neovim via Homebrew (mac):
  - brew update
  - brew install neovim    # or brew upgrade neovim
  - or for latest dev: brew install --HEAD neovim
  - Confirm: which nvim && nvim --version

- Headless Packer sync:
  - nvim --headless -c 'autocmd User PackerComplete quitall' -c 'PackerSync'

- Force reinstall plugins (if pinned/old):
  - rm -rf ~/.local/share/nvim/site/pack/packer/start/nvim-lspconfig
  - rm -rf ~/.local/share/nvim/site/pack/packer/start/lsp-zero.nvim
  - nvim --headless -c 'autocmd User PackerComplete quitall' -c 'PackerSync'

- Check available mason servers:
  - nvim --headless -c "lua print(vim.inspect(require('mason-lspconfig').get_available_servers()))" -c qa

- Test reload single file:
  - In Neovim: :luafile $HOME/.config/nvim/after/plugin/bufferline.lua
  - Check messages: :messages
  - Run health: :checkhealth

Example defensive snippets applied
----------------------------------
- Bufferline get_element_icon (concept, simplified):
```lua
-- filepath: [bufferline.lua](http://_vscodecontentref_/0)
-- ...existing code...
get_element_icon = function(element)
  local ok, webdev_icons = pcall(require, "nvim-web-devicons")
  if not ok or not webdev_icons then
    return nil
  end
  local filename = element.path or ""
  local name = vim.fn.fnamemodify(filename, ":t")
  local icon, hl = webdev_icons.get_icon(name, element.extension, { default = true })
  return icon, hl
end
-- ...existing code...
```