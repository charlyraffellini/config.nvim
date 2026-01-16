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

-- Try immediately; if telescope isn't installed/loaded yet, retry after events
if not try_setup_telescope() then
  local aug = vim.api.nvim_create_augroup("ElRafaTelescopeDeferred", { clear = true })

  -- Retry on startup and after packer completes installs
  vim.api.nvim_create_autocmd({ "VimEnter", "User" }, {
    group = aug,
    pattern = { "PackerComplete" },
    callback = function()
      -- small defer to let plugin loader finish
      vim.defer_fn(function()
        try_setup_telescope()
      end, 150)
    end,
    once = true,
  })

  -- Also attempt on BufEnter in case telescope loads lazily later
  vim.api.nvim_create_autocmd("BufEnter", {
    group = aug,
    callback = function()
      if try_setup_telescope() then
        vim.api.nvim_del_augroup_by_id(aug)
      end
    end,
  })
end
