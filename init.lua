require("elrafa")

-- this is not necessary instead go to ~/.config/nvim/lua/elrafa/packer.lua and call :source % and then :PackerSync
--require('packer').startup(function(use)
--  use 'wbthomason/packer.nvim'
--end)

--vim.opt.runtimepath:append(',~/src/vim-visual-multi/autoload/vm.vim')

-- I got how to set up plug in init.lua here: https://vonheikemen.github.io/devlog/tools/configuring-neovim-using-lua/
local Plug = vim.fn['plug#']

vim.call('plug#begin', '~/.config/nvim/plugged')

Plug('mg979/vim-visual-multi', {['branch'] = 'master'})
Plug('RishabhRD/popfix')
Plug('RishabhRD/nvim-lsputils')

vim.call('plug#end')

require('elrafa.packer')

print("Hello from elrafa")
