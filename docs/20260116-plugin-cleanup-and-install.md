# 2026-01-16 — Plugin cleanup, reinstall Packer & plugins, and idempotent Telescope mapper

This document describes how to:
- delete all installed plugins,
- reinstall Packer,
- reinstall all plugins via Packer,
- add an idempotent deferred Telescope keymap that only applies when Telescope is available.

Important: back up your config before running destructive commands:
```bash
cp -a ~/.config/nvim ~/.config/nvim.bak
```

1) Delete all plugins (safe)
- Remove all plugins installed by Packer (start and opt):
```bash
rm -rf ~/.local/share/nvim/site/pack/packer/start/*
rm -rf ~/.local/share/nvim/site/pack/packer/opt/*
# remove cached luarocks created by packer (optional)
rm -rf ~/.cache/nvim/packer_hererocks
# remove compiled loader so it will be regenerated
rm -f ~/.config/nvim/plugin/packer_compiled.lua
```

2) Reinstall Packer
- Install Packer into the start directory so it's immediately available:
```bash
git clone --depth 1 https://github.com/wbthomason/packer.nvim \
  ~/.local/share/nvim/site/pack/packer/start/packer.nvim
```
- (Alternative: install into opt and use `packadd packer.nvim` in your packer.lua)

3) Reinstall all plugins (via PackerSync)
- Run headless sync to install plugins and let Packer regenerate loader files:
```bash
nvim --headless -c 'autocmd User PackerComplete quitall' -c 'PackerSync'
```
- After that completes, open Neovim and run:
```vim
:checkhealth
:messages
```

4) Verify mason / lsp / telescope availability
- Check mason-lspconfig available servers:
```bash
nvim --headless -c "lua print(vim.inspect(require('mason-lspconfig').get_available_servers()))" -c qa
```
- If any plugin reports missing setup (e.g. "mason.nvim has not been set up") ensure that plugin is listed in your packer.lua and not loaded too early.

5) Idempotent deferred Telescope keymaps (apply safely)
- Add this snippet (or replace your after/plugin/telescope.lua) so keymaps are only created when Telescope is available. It will retry after startup and after Packer completes installs.

```lua
-- filepath: /Users/carlos.raffellini/.config/nvim/after/plugin/telescope.lua
-- Safe deferred Telescope keymaps: set once when telescope becomes available
local function apply_telescope_maps(builtin)
  if _G.__elrafa_telescope_mapped then return end
  _G.__elrafa_telescope_mapped = true

  vim.keymap.set('n', '<leader>pf', builtin.find_files, { desc = "Telescope find files" })
  vim.keymap.set('n', '<C-p>', builtin.git_files, { desc = "Telescope git files" })
  vim.keymap.set('n', '<leader>ps', function()
    builtin.grep_string({ search = vim.fn.input("Grep > ") })
  end, { desc = "Telescope grep" })
  vim.keymap.set('n', '<leader>vh', builtin.help_tags, { desc = "Telescope help tags" })
  vim.keymap.set('n', '<leader>pa', function()
    builtin.lsp_workspace_symbols({ query = vim.fn.input("Workspace symbol > ") })
  end, { desc = "Telescope workspace symbols" })
end

local function try_setup_telescope()
  local ok, builtin = pcall(require, "telescope.builtin")
  if ok and builtin then
    apply_telescope_maps(builtin)
    return true
  end
  return false
end

if not try_setup_telescope() then
  local aug = vim.api.nvim_create_augroup("ElRafaTelescopeDeferred", { clear = true })

  vim.api.nvim_create_autocmd({ "VimEnter", "User" }, {
    group = aug,
    pattern = { "PackerComplete" },
    callback = function()
      vim.defer_fn(function() try_setup_telescope() end, 150)
    end,
    once = true,
  })

  vim.api.nvim_create_autocmd("BufEnter", {
    group = aug,
    callback = function()
      if try_setup_telescope() then
        pcall(vim.api.nvim_del_augroup_by_name, "ElRafaTelescopeDeferred")
      end
    end,
  })
end
```

6) Post-clean steps and checks
- Run plugin update again after first install:
```bash
nvim --headless -c 'autocmd User PackerComplete quitall' -c 'PackerSync'
```
- Open Neovim:
```bash
nvim
# then inside:
:checkhealth
:messages
```
- Remove any temporary compatibility shims (e.g., compat_tbl_islist.lua) once all plugins are updated and deprecation warnings are gone:
```bash
rm ~/.config/nvim/after/plugin/compat_tbl_islist.lua
```

7) If you prefer to remove offending plugins permanently
- Edit your packer.lua and remove or comment their use(...) lines (e.g. telescope, bufferline, lsp-zero, mason, mason-lspconfig).
- Then run PackerSync to uninstall them:
```bash
nvim --headless -c 'autocmd User PackerComplete quitall' -c 'PackerSync'
```

Notes
- Keep packer_compiled.lua removed while debugging and let Packer regenerate it.
- If any plugin fails to install, check $HOME/.local/share/nvim/site/pack/packer/start for its directory and the output of PackerSync.
- Always keep a backup of your config before destructive operations.

End of document
```// filepath: /Users/carlos.raffellini/.config/nvim/docs/20260116-plugin-cleanup-and-install.md
# 2026-01-16 — Plugin cleanup, reinstall Packer & plugins, and idempotent Telescope mapper

This document describes how to:
- delete all installed plugins,
- reinstall Packer,
- reinstall all plugins via Packer,
- add an idempotent deferred Telescope keymap that only applies when Telescope is available.

Important: back up your config before running destructive commands:
```bash
cp -a ~/.config/nvim ~/.config/nvim.bak
```

1) Delete all plugins (safe)
- Remove all plugins installed by Packer (start and opt):
```bash
rm -rf ~/.local/share/nvim/site/pack/packer/start/*
rm -rf ~/.local/share/nvim/site/pack/packer/opt/*
# remove cached luarocks created by packer (optional)
rm -rf ~/.cache/nvim/packer_hererocks
# remove compiled loader so it will be regenerated
rm -f ~/.config/nvim/plugin/packer_compiled.lua
```

2) Reinstall Packer
- Install Packer into the start directory so it's immediately available:
```bash
git clone --depth 1 https://github.com/wbthomason/packer.nvim \
  ~/.local/share/nvim/site/pack/packer/start/packer.nvim
```
- (Alternative: install into opt and use `packadd packer.nvim` in your packer.lua)

3) Reinstall all plugins (via PackerSync)
- Run headless sync to install plugins and let Packer regenerate loader files:
```bash
nvim --headless -c 'autocmd User PackerComplete quitall' -c 'PackerSync'
```
- After that completes, open Neovim and run:
```vim
:checkhealth
:messages
```

4) Verify mason / lsp / telescope availability
- Check mason-lspconfig available servers:
```bash
nvim --headless -c "lua print(vim.inspect(require('mason-lspconfig').get_available_servers()))" -c qa
```
- If any plugin reports missing setup (e.g. "mason.nvim has not been set up") ensure that plugin is listed in your packer.lua and not loaded too early.

5) Idempotent deferred Telescope keymaps (apply safely)
- Add this snippet (or replace your after/plugin/telescope.lua) so keymaps are only created when Telescope is available. It will retry after startup and after Packer completes installs.

```lua
-- filepath: /Users/carlos.raffellini/.config/nvim/after/plugin/telescope.lua
-- Safe deferred Telescope keymaps: set once when telescope becomes available
local function apply_telescope_maps(builtin)
  if _G.__elrafa_telescope_mapped then return end
  _G.__elrafa_telescope_mapped = true

  vim.keymap.set('n', '<leader>pf', builtin.find_files, { desc = "Telescope find files" })
  vim.keymap.set('n', '<C-p>', builtin.git_files, { desc = "Telescope git files" })
  vim.keymap.set('n', '<leader>ps', function()
    builtin.grep_string({ search = vim.fn.input("Grep > ") })
  end, { desc = "Telescope grep" })
  vim.keymap.set('n', '<leader>vh', builtin.help_tags, { desc = "Telescope help tags" })
  vim.keymap.set('n', '<leader>pa', function()
    builtin.lsp_workspace_symbols({ query = vim.fn.input("Workspace symbol > ") })
  end, { desc = "Telescope workspace symbols" })
end

local function try_setup_telescope()
  local ok, builtin = pcall(require, "telescope.builtin")
  if ok and builtin then
    apply_telescope_maps(builtin)
    return true
  end
  return false
end

if not try_setup_telescope() then
  local aug = vim.api.nvim_create_augroup("ElRafaTelescopeDeferred", { clear = true })

  vim.api.nvim_create_autocmd({ "VimEnter", "User" }, {
    group = aug,
    pattern = { "PackerComplete" },
    callback = function()
      vim.defer_fn(function() try_setup_telescope() end, 150)
    end,
    once = true,
  })

  vim.api.nvim_create_autocmd("BufEnter", {
    group = aug,
    callback = function()
      if try_setup_telescope() then
        pcall(vim.api.nvim_del_augroup_by_name, "ElRafaTelescopeDeferred")
      end
    end,
  })
end
```

6) Post-clean steps and checks
- Run plugin update again after first install:
```bash
nvim --headless -c 'autocmd User PackerComplete quitall' -c 'PackerSync'
```
- Open Neovim:
```bash
nvim
# then inside:
:checkhealth
:messages
```
- Remove any temporary compatibility shims (e.g., compat_tbl_islist.lua) once all plugins are updated and deprecation warnings are gone:
```bash
rm ~/.config/nvim/after/plugin/compat_tbl_islist.lua
```

7) If you prefer to remove offending plugins permanently
- Edit your packer.lua and remove or comment their use(...) lines (e.g. telescope, bufferline, lsp-zero, mason, mason-lspconfig).
- Then run PackerSync to uninstall them:
```bash
nvim --headless -c 'autocmd User PackerComplete quitall' -c 'PackerSync'
```

Notes
- Keep packer_compiled.lua removed while debugging and let Packer regenerate it.
- If any plugin fails to install, check $HOME/.local/share/nvim/site/pack/packer/start for its directory and the output of PackerSync.
- Always keep a backup of your config before destructive operations.

End of document