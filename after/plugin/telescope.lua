local builtin = require('telescope.builtin')
vim.keymap.set('n', '<leader>pf', builtin.find_files, {})
vim.keymap.set('n', '<C-p>', builtin.git_files, {})
vim.keymap.set('n', '<leader>ps', function()
	builtin.grep_string({ search = vim.fn.input("Grep > ") })
end)
vim.keymap.set('n', '<leader>vh', builtin.help_tags, {})

vim.keymap.set('n', '<leader>pa', function()
	builtin.lsp_workspace_symbols({ query = vim.fn.input("Workspace symbol > ") })
end)

--Off because nvim.material disabled
--vim.keymap.set('n', '<leader>sc', function()
--    require("material.functions").find_style()
--end)
