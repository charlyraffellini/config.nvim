require("elrafa")
--vim.opt.runtimepath:append(',~/src/vim-visual-multi/autoload/vm.vim')

-- I got how to set up plug in init.lua here: https://vonheikemen.github.io/devlog/tools/configuring-neovim-using-lua/
local Plug = vim.fn['plug#']

vim.call('plug#begin', '~/.config/nvim/plugged')

Plug('mg979/vim-visual-multi', {['branch'] = 'master'})

vim.call('plug#end')


print("Hello from elrafa")
