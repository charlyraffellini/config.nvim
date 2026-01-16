# Custom Shortcuts (project scan)

This document lists custom key mappings found in the config, the file where each is defined, and a short description.

- lua/elrafa/remap.lua
  - n, <leader>pv → vim.cmd.Ex
    - Open Ex / file explorer
  - v, J → :m '>+1<CR>gv=gv
    - Move visual selection down
  - v, K → :m '<-2<CR>gv=gv
    - Move visual selection up
  - n, J → mzJ`z
    - Join line without moving cursor
  - n, <C-d> → <C-d>zz
    - Page down and center cursor
  - n, <C-u> → <C-u>zz
    - Page up and center cursor
  - n, n → nzzzv
    - Go to next search result and center/unfold
  - n, N → Nzzzv
    - Go to previous search result and center/unfold
  - n, <leader>vwm → <function>
    - Project-specific mapping (see file for function body)
  - n, <leader>svwm → <function>
    - Project-specific mapping (see file for function body)
  - x, <leader>p → [["_dP]]
    - Paste over visual selection without clobbering register
  - n/v, <leader>y → [["+y]]
    - Yank to system clipboard
  - n, <leader>Y → [["+Y]]
    - Yank line to system clipboard
  - n/v, <leader>d → [["_d]]
    - Delete to black hole register
  - i, <C-c> → <Esc>
    - Make Ctrl-C act like Escape in insert mode
  - n, Q → <nop>
    - Disable Ex mode
  - n, <C-f> → <cmd>silent !tmux neww tmux-sessionizer<CR>
    - Open tmux sessionizer (external command)
  - n, <leader>f → vim.lsp.buf.format
    - Format current buffer (LSP)
  - n, <C-k> → <cmd>cnext<CR>zz
    - Quickfix next and center
  - n, <C-j> → <cmd>cprev<CR>zz
    - Quickfix previous and center
  - n, <leader>k → <cmd>lnext<CR>zz
    - Location list next and center
  - n, <leader>j → <cmd>lprev<CR>zz
    - Location list previous and center
  - n, <leader>s → :%s/\<<C-r><C-w>\>/<C-r><C-w>/gI<Left><Left><Left>
    - Find-and-replace word under cursor (interactive)
  - n, <leader>x → <cmd>!chmod +x %<CR> (silent)
    - Make current file executable
  - n, <leader>vpp → open packer.lua in dotfiles path
    - Quick edit of packer file in dotfiles
  - n, <leader>mr → <cmd>CellularAutomaton make_it_rain<CR>
    - Run CellularAutomaton example
  - n, <leader><leader> → <function>
    - Project-specific mapping (see file)

- after/plugin/metals.lua
  - n, gD → vim.lsp.buf.definition
  - n, K → vim.lsp.buf.hover
  - n, gi → vim.lsp.buf.implementation
  - n, gr → vim.lsp.buf.references
  - n, gds → vim.lsp.buf.document_symbol
  - n, gws → vim.lsp.buf.workspace_symbol
  - n, <leader>cl → vim.lsp.codelens.run
  - n, <leader>sh → vim.lsp.buf.signature_help
  - n, <leader>rn → vim.lsp.buf.rename
  - n, <leader>f → LSP-specific format (may conflict with remap.lua)
  - n, <leader>ca → vim.lsp.buf.code_action
  - n, <leader>ws → <function> (workspace symbols)
  - n, <leader>aa → vim.diagnostic.setqflist
  - n, <leader>ae → <function>
  - n, <leader>aw → <function>
  - n, <leader>d → vim.diagnostic.setloclist
  - n, [c → <function> (prev diagnostic)
  - n, ]c → <function> (next diagnostic)
  - n, <leader>dc / dr / dK / dt / dso / dsi / dl → various diagnostic / repl / test helpers
    - See file for exact behavior (Metals integrations)

- after/plugin/zenmode.lua
  - n, <leader>zz → toggle zen mode (function)
  - n, <leader>zZ → alternate zen toggle (function)

- after/plugin/telescope.lua
  - n, <leader>pf → builtin.find_files
    - Telescope find files (deferred mapping)
  - n, <C-p> → builtin.git_files
    - Telescope git files (deferred mapping)
  - n, <leader>ps → builtin.grep_string with prompt
    - Live grep (deferred mapping)
  - n, <leader>vh → builtin.help_tags
    - Help tags search (deferred mapping)
  - n, <leader>pa → builtin.lsp_workspace_symbols with prompt
    - Workspace symbol search (deferred mapping)

- after/plugin/trouble.lua
  - n, <leader>xq → <cmd>TroubleToggle quickfix<cr>
    - Toggle Trouble quickfix list

- after/plugin/refactoring.lua
  - v, <leader>ri → Inline Variable (refactoring plugin)
    - Refactor Inline Variable in visual selection

- after/plugin/fugitive.lua
  - n, <leader>gs → vim.cmd.Git
    - Open fugitive Git status
  - n, <leader>p → <function>
  - n, <leader>P → <function>
  - n, <leader>t → :Git push -u origin (partial command)
    - Git push helpers (see file for details)

- after/plugin/bufferline.lua
  - n, <S-l> → <CMD>BufferLineCycleNext<CR>
    - Cycle bufferline right
  - n, <S-h> → <CMD>BufferLineCyclePrev<CR>
    - Cycle bufferline left

- after/plugin/harpoon.lua
  - n, <leader>a → mark.add_file
    - Add file to Harpoon marks
  - n, <C-e> → ui.toggle_quick_menu
    - Toggle Harpoon quick menu
  - n, <C-h> → ui.nav_file(1)
    - Go to Harpoon mark 1
  - n, <C-t> → ui.nav_file(2)
    - Go to Harpoon mark 2

- after/plugin/undotree.lua
  - n, <leader>u → vim.cmd.UndotreeToggle
    - Toggle Undotree

Notes and recommendations
- Two mappings use `<leader>f`: one in remap.lua (LSP format) and one in metals.lua (Metals format). Consider consolidating or scoping (buffer-local) to avoid conflict.
- Several mappings call project-specific functions; inspect the source files for exact behavior before changing.
- Deferred/idempotent mapping pattern is used for Telescope to avoid errors when plugin is not installed. Follow same pattern for other plugin keymaps that run at startup.
- To produce a printable/CSV report, say "export" and I will generate a machine-readable table.

If you want, I will:
- Commit this file to docs/custom-shortcuts.md, or
- Produce replacements to make mappings buffer-local where appropriate (e.g. Metals LSP) — tell me which change to apply.
```<!-- filepath: /Users/carlos.raffellini/.config/nvim/docs/custom-shortcuts.md -->
# Custom Shortcuts (project scan)

This document lists custom key mappings found in the config, the file where each is defined, and a short description.

- lua/elrafa/remap.lua
  - n, <leader>pv → vim.cmd.Ex
    - Open Ex / file explorer
  - v, J → :m '>+1<CR>gv=gv
    - Move visual selection down
  - v, K → :m '<-2<CR>gv=gv
    - Move visual selection up
  - n, J → mzJ`z
    - Join line without moving cursor
  - n, <C-d> → <C-d>zz
    - Page down and center cursor
  - n, <C-u> → <C-u>zz
    - Page up and center cursor
  - n, n → nzzzv
    - Go to next search result and center/unfold
  - n, N → Nzzzv
    - Go to previous search result and center/unfold
  - n, <leader>vwm → <function>
    - Project-specific mapping (see file for function body)
  - n, <leader>svwm → <function>
    - Project-specific mapping (see file for function body)
  - x, <leader>p → [["_dP]]
    - Paste over visual selection without clobbering register
  - n/v, <leader>y → [["+y]]
    - Yank to system clipboard
  - n, <leader>Y → [["+Y]]
    - Yank line to system clipboard
  - n/v, <leader>d → [["_d]]
    - Delete to black hole register
  - i, <C-c> → <Esc>
    - Make Ctrl-C act like Escape in insert mode
  - n, Q → <nop>
    - Disable Ex mode
  - n, <C-f> → <cmd>silent !tmux neww tmux-sessionizer<CR>
    - Open tmux sessionizer (external command)
  - n, <leader>f → vim.lsp.buf.format
    - Format current buffer (LSP)
  - n, <C-k> → <cmd>cnext<CR>zz
    - Quickfix next and center
  - n, <C-j> → <cmd>cprev<CR>zz
    - Quickfix previous and center
  - n, <leader>k → <cmd>lnext<CR>zz
    - Location list next and center
  - n, <leader>j → <cmd>lprev<CR>zz
    - Location list previous and center
  - n, <leader>s → :%s/\<<C-r><C-w>\>/<C-r><C-w>/gI<Left><Left><Left>
    - Find-and-replace word under cursor (interactive)
  - n, <leader>x → <cmd>!chmod +x %<CR> (silent)
    - Make current file executable
  - n, <leader>vpp → open packer.lua in dotfiles path
    - Quick edit of packer file in dotfiles
  - n, <leader>mr → <cmd>CellularAutomaton make_it_rain<CR>
    - Run CellularAutomaton example
  - n, <leader><leader> → <function>
    - Project-specific mapping (see file)

- after/plugin/metals.lua
  - n, gD → vim.lsp.buf.definition
  - n, K → vim.lsp.buf.hover
  - n, gi → vim.lsp.buf.implementation
  - n, gr → vim.lsp.buf.references
  - n, gds → vim.lsp.buf.document_symbol
  - n, gws → vim.lsp.buf.workspace_symbol
  - n, <leader>cl → vim.lsp.codelens.run
  - n, <leader>sh → vim.lsp.buf.signature_help
  - n, <leader>rn → vim.lsp.buf.rename
  - n, <leader>f → LSP-specific format (may conflict with remap.lua)
  - n, <leader>ca → vim.lsp.buf.code_action
  - n, <leader>ws → <function> (workspace symbols)
  - n, <leader>aa → vim.diagnostic.setqflist
  - n, <leader>ae → <function>
  - n, <leader>aw → <function>
  - n, <leader>d → vim.diagnostic.setloclist
  - n, [c → <function> (prev diagnostic)
  - n, ]c → <function> (next diagnostic)
  - n, <leader>dc / dr / dK / dt / dso / dsi / dl → various diagnostic / repl / test helpers
    - See file for exact behavior (Metals integrations)

- after/plugin/zenmode.lua
  - n, <leader>zz → toggle zen mode (function)
  - n, <leader>zZ → alternate zen toggle (function)

- after/plugin/telescope.lua
  - n, <leader>pf → builtin.find_files
    - Telescope find files (deferred mapping)
  - n, <C-p> → builtin.git_files
    - Telescope git files (deferred mapping)
  - n, <leader>ps → builtin.grep_string with prompt
    - Live grep (deferred mapping)
  - n, <leader>vh → builtin.help_tags
    - Help tags search (deferred mapping)
  - n, <leader>pa → builtin.lsp_workspace_symbols with prompt
    - Workspace symbol search (deferred mapping)

- after/plugin/trouble.lua
  - n, <leader>xq → <cmd>TroubleToggle quickfix<cr>
    - Toggle Trouble quickfix list

- after/plugin/refactoring.lua
  - v, <leader>ri → Inline Variable (refactoring plugin)
    - Refactor Inline Variable in visual selection

- after/plugin/fugitive.lua
  - n, <leader>gs → vim.cmd.Git
    - Open fugitive Git status
  - n, <leader>p → <function>
  - n, <leader>P → <function>
  - n, <leader>t → :Git push -u origin (partial command)
    - Git push helpers (see file for details)

- after/plugin/bufferline.lua
  - n, <S-l> → <CMD>BufferLineCycleNext<CR>
    - Cycle bufferline right
  - n, <S-h> → <CMD>BufferLineCyclePrev<CR>
    - Cycle bufferline left

- after/plugin/harpoon.lua
  - n, <leader>a → mark.add_file
    - Add file to Harpoon marks
  - n, <C-e> → ui.toggle_quick_menu
    - Toggle Harpoon quick menu
  - n, <C-h> → ui.nav_file(1)
    - Go to Harpoon mark 1
  - n, <C-t> → ui.nav_file(2)
    - Go to Harpoon mark 2

- after/plugin/undotree.lua
  - n, <leader>u → vim.cmd.UndotreeToggle
    - Toggle Undotree

Notes and recommendations
- Two mappings use `<leader>f`: one in remap.lua (LSP format) and one in metals.lua (Metals format). Consider consolidating or scoping (buffer-local) to avoid conflict.
- Several mappings call project-specific functions; inspect the source files for exact behavior before changing.
- Deferred/idempotent mapping pattern is used for Telescope to avoid errors when plugin is not installed. Follow same pattern for other plugin keymaps that run at startup.
- To produce a printable/CSV report, say "export" and I will generate a machine-readable table.

If you want, I will:
- Commit this file to docs/custom-shortcuts.md, or
- Produce replacements to make mappings buffer-local where appropriate (e.g. Metals LSP) — tell me which change to apply.