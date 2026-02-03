# Auto-Save Feature Implementation

**Date:** 2026-02-03  
**Feature:** Automatic file saving on text changes and insert mode exit

## Overview

This document explains the end-to-end implementation of the auto-save feature in Neovim using Lua. The feature automatically saves modified files when leaving insert mode or after text changes, with the ability to toggle it on/off.

## Architecture

The auto-save feature consists of three main components:

1. **Lua Module** (`lua/elrafa/autosave.lua`) - Core logic
2. **Keybinding** (`lua/elrafa/remap.lua`) - User interaction
3. **Module Loading** (`lua/elrafa/init.lua`) - Initialization

## Implementation Details

### 1. Lua Module (`lua/elrafa/autosave.lua`)

The module exports a Lua table with state and functions:

```lua
local M = {}

-- Start as false because M.toggle() at the end will flip it to true
M.enabled = false

function M.toggle()
    M.enabled = not M.enabled
    if M.enabled then
        -- Create autocommand group and register autocmds
        vim.api.nvim_create_augroup("AutoSave", { clear = true })
        vim.api.nvim_create_autocmd({ "InsertLeave", "TextChanged" }, {
            group = "AutoSave",
            pattern = "*",
            callback = function()
                -- Only save if file is modified, writable, named, and not special buffer
                if vim.bo.modified and not vim.bo.readonly and 
                   vim.fn.expand("%") ~= "" and vim.bo.buftype == "" then
                    vim.cmd("silent! write")
                end
            end,
        })
        print("Autosave enabled")
    else
        -- Clear autocommand group to disable
        vim.api.nvim_create_augroup("AutoSave", { clear = true })
        print("Autosave disabled")
    end
end

-- Initialize autosave on module load
M.toggle()

return M
```

**Key Concepts:**

- **Module Pattern**: Lua uses tables as modules. `local M = {}` creates a table that will be returned at the end
- **State Management**: `M.enabled` tracks whether autosave is active
- **Autocommand Groups**: Named collections of autocommands that can be cleared as a unit
- **Events**: 
  - `InsertLeave` - Triggered when exiting insert mode
  - `TextChanged` - Triggered when buffer text changes in normal mode
- **Buffer Options (`vim.bo`)**:
  - `modified` - Has the buffer been changed?
  - `readonly` - Is the buffer read-only?
  - `buftype` - Is it a special buffer (quickfix, help, etc.)?

### 2. Neovim Lua API Integration

The feature uses several Neovim Lua APIs:

#### `vim.api.nvim_create_augroup(name, opts)`
Creates or gets an autocommand group. The `{ clear = true }` option removes all existing autocommands in the group.

#### `vim.api.nvim_create_autocmd(events, opts)`
Registers autocommands for specific events:
- `events`: Array of event names (`InsertLeave`, `TextChanged`)
- `group`: Associates with an augroup for easy management
- `pattern`: File pattern to match ("`*`" = all files)
- `callback`: Lua function to execute when event fires

#### `vim.cmd(command)`
Executes Vim Ex commands. `"silent! write"` saves the file, suppressing errors.

### 3. Keybinding (`lua/elrafa/remap.lua`)

```lua
vim.keymap.set("n", "<leader>as", function()
    require("elrafa.autosave").toggle()
end, { desc = "Toggle autosave" })
```

**How it works:**
- `vim.keymap.set()` registers a keybinding
- Mode: `"n"` (normal mode)
- Key: `"<leader>as"` (Space + a + s, since leader is Space)
- Action: Anonymous function that requires the module and calls toggle
- `require()` returns the cached module if already loaded

### 4. Module Loading (`lua/elrafa/init.lua`)

```lua
require("elrafa.set")
require("elrafa.remap")
require("elrafa.autosave")
```

**Module Resolution:**
- `require("elrafa.autosave")` looks for `lua/elrafa/autosave.lua`
- Lua's module system caches loaded modules
- The module executes once on first require, calling `M.toggle()` to enable by default

### 5. Main Config (`init.lua`)

```lua
require("elrafa")
```

This loads `lua/elrafa/init.lua`, which chains to load all sub-modules including autosave.

## Execution Flow

### Startup Flow

1. Neovim starts and sources `init.lua`
2. `require("elrafa")` loads `lua/elrafa/init.lua`
3. `require("elrafa.autosave")` loads and executes `lua/elrafa/autosave.lua`
4. Module initialization calls `M.toggle()`
5. Since `M.enabled = false`, toggle flips it to `true`
6. Autocommand group "AutoSave" is created
7. Two autocommands are registered for `InsertLeave` and `TextChanged`
8. "Autosave enabled" message displays

### Runtime Flow (When Editing)

1. User edits a file and exits insert mode → `InsertLeave` event fires
2. Autocommand callback checks:
   - Is buffer modified? (`vim.bo.modified`)
   - Is it writable? (`not vim.bo.readonly`)
   - Does it have a name? (`vim.fn.expand("%") ~= ""`)
   - Is it a normal buffer? (`vim.bo.buftype == ""`)
3. If all conditions pass → Execute `vim.cmd("silent! write")`
4. File is saved to disk

### Toggle Flow (User presses `<leader>as`)

1. Keybinding triggers anonymous function
2. `require("elrafa.autosave")` returns cached module
3. `.toggle()` function is called
4. `M.enabled` is flipped
5. If enabling: Create augroup and register autocmds
6. If disabling: Clear augroup (removes all autocmds)
7. Print status message

## Lua VM Concepts

### Module Caching
- Lua caches modules in `package.loaded` table
- First `require()` loads and executes the file
- Subsequent `require()` calls return the cached table
- This means `M.toggle()` at module end only runs once

### Closures and State
- The `M` table persists in memory after module loads
- `M.enabled` maintains state between toggle calls
- Functions in `M` have access to the module's local scope

### Callbacks
- `callback = function() ... end` creates a closure
- The function captures references to Neovim APIs
- Runs in Lua VM context when events trigger
- Has access to current buffer state via `vim.bo`, `vim.fn`, etc.

## Why Start with `M.enabled = false`?

This is counterintuitive but necessary:
- We want autosave **enabled by default**
- Module initialization calls `M.toggle()`
- Toggle does `M.enabled = not M.enabled`
- Starting with `false` → toggles to `true` ✓
- Starting with `true` → toggles to `false` ✗

Alternative would be to call `M.enable()` directly instead of `M.toggle()`, but toggle provides the initialization logic we need.

## Files Modified

1. **Created**: `lua/elrafa/autosave.lua` - Main module
2. **Modified**: `lua/elrafa/remap.lua` - Added keybinding
3. **Modified**: `lua/elrafa/init.lua` - Added module loading
4. **Modified**: `docs/custom-shortcuts.md` - Documented keybinding

## Testing

To verify the feature works:
1. Open a file in Neovim
2. Make changes
3. Exit insert mode or change text
4. Check file modification time: `:!ls -la %`
5. Toggle off: `<leader>as`
6. Make changes - file should NOT auto-save
7. Toggle on: `<leader>as`
8. Make changes - file should auto-save again

## Debugging

If autosave isn't working:
- Check if module loaded: `:lua print(require("elrafa.autosave").enabled)`
- List autocommands: `:autocmd AutoSave`
- Check buffer options: `:set modified? readonly? buftype?`
- Enable verbose: `:set verbose=9` before triggering events

## References

- [Neovim Lua API](https://neovim.io/doc/user/lua.html)
- [Autocommands in Lua](https://neovim.io/doc/user/api.html#api-autocmd)
- [Lua Modules](https://www.lua.org/manual/5.1/manual.html#5.3)
