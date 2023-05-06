require("elrafa")
--vim.opt.runtimepath:append(',~/src/vim-visual-multi/autoload/vm.vim')

local Plug = vim.fn['plug#']

vim.call('plug#begin', '~/.config/nvim/plugged')

Plug('mg979/vim-visual-multi')

vim.call('plug#end')


print("Hello from elrafa")
