--change it to a toggle command
--local create_cmd = vim.api.nvim_create_user_command

-- create_cmd("ToggleBackground", function ()
--    if vim.o.background == 'dark' then
--        vim.cmd'set bg=light'
--    else
--        vim.cmd'set bg=dark'
--    end
--end, {})
-- vim.cmd'set bg=light'

vim.opt.laststatus = 2 -- Or 3 for global statusline
vim.opt.statusline = " %F %m %= %l:%c "

vim.opt.guicursor = {
    "n-v:block",
    "i-c-ci-ve:ver25",
    "r-cr:hor20",
    "o:hor50",
    "i:blinkwait700-blinkoff400-blinkon250-Cursor/lCursor",
    "sm:block-blinkwait175-blinkoff150-blinkon175",
}

require('rose-pine').setup({
   -- disable_background = true,
    --dark_variant = 'main',
    -- variant = 'dawn',
    variant = 'main',
    disable_italics = true,
    highlight_groups = {
		StatusLine = { fg = "iris", bg = "iris", blend = 10 },
		StatusLineNC = { fg = "base", bg = "subtle" },
        CursorLine = { bg = 'foam', blend = 10 },
	},
})

function ColorMyPencils(color)
	color = color or "rose-pine"
	vim.cmd.colorscheme(color)

	--vim.api.nvim_set_hl(0, "Normal", { bg = "none" })
	--vim.api.nvim_set_hl(0, "NormalFloat", { bg = "none" })

end

ColorMyPencils()
