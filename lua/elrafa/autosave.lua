-- Autosave functionality
local M = {}

-- Start as false because M.toggle() at the end will flip it to true (enabled by default)
M.enabled = false

function M.toggle()
    M.enabled = not M.enabled
    if M.enabled then
        vim.api.nvim_create_augroup("AutoSave", { clear = true })
        vim.api.nvim_create_autocmd({ "InsertLeave", "TextChanged" }, {
            group = "AutoSave",
            pattern = "*",
            callback = function()
                if vim.bo.modified and not vim.bo.readonly and vim.fn.expand("%") ~= "" and vim.bo.buftype == "" then
                    vim.cmd("silent! write")
                end
            end,
        })
        print("Autosave enabled")
    else
        vim.api.nvim_create_augroup("AutoSave", { clear = true })
        print("Autosave disabled")
    end
end

function M.enable()
    if not M.enabled then
        M.toggle()
    end
end

function M.disable()
    if M.enabled then
        M.toggle()
    end
end

-- Initialize autosave on module load since default is true
M.toggle()

return M
