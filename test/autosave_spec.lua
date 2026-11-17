-- Each spec runs in a fresh Neovim instance (plenary), so the real config is not affected.
-- Run: nvim --headless -u NONE -c "set rtp+=~/.config/nvim,<path-to-plenary>" -c "PlenaryBustedDirectory test"
local function autosave_cmds()
  return vim.api.nvim_get_autocmds({ group = "AutoSave" })
end

describe("elrafa.autosave", function()
  local autosave

  before_each(function()
    package.loaded["elrafa.autosave"] = nil
    autosave = require("elrafa.autosave")
  end)

  it("is enabled on load", function()
    assert.is_true(autosave.enabled)
    assert.is_true(#autosave_cmds() > 0)
  end)

  it("toggle disables and re-enables", function()
    autosave.toggle()
    assert.is_false(autosave.enabled)
    assert.are.equal(0, #autosave_cmds())
    autosave.toggle()
    assert.is_true(autosave.enabled)
  end)

  it("enable/disable are idempotent", function()
    autosave.disable()
    autosave.disable()
    assert.is_false(autosave.enabled)
    autosave.enable()
    autosave.enable()
    assert.is_true(autosave.enabled)
  end)

  it("writes a modified buffer on InsertLeave", function()
    local path = vim.fn.tempname()
    vim.cmd("edit " .. path)
    vim.api.nvim_buf_set_lines(0, 0, -1, false, { "hello" })
    vim.api.nvim_exec_autocmds("InsertLeave", {})
    assert.are.same({ "hello" }, vim.fn.readfile(path))
    os.remove(path)
  end)
end)
