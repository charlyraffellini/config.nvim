----------------------------------
-- LSP Metals Setup --------------
----------------------------------
local api = vim.api
local cmd = vim.cmd

local metals_config = require("metals").bare_config()

-- Example of settings
metals_config.settings = {
  showImplicitArguments = true,
  excludedPackages = { "akka.actor.typed.javadsl", "com.github.swagger.akka.javadsl" },
}

-- *READ THIS*
-- I *highly* recommend setting statusBarProvider to true, however if you do,
-- you *have* to have a setting to display this in your statusline or else
-- you'll not see any messages from metals. There is more info in the help
-- docs about this
-- metals_config.init_options.statusBarProvider = "on"

-- Example if you are using cmp how to make sure the correct capabilities for snippets are set
metals_config.capabilities = require("cmp_nvim_lsp").default_capabilities()

-- Debug settings if you're using nvim-dap
local dap = require("dap")

dap.configurations.scala = {
  {
    type = "scala",
    request = "launch",
    name = "RunOrTest",
    metals = {
      runType = "runOrTestFile",
      --args = { "firstArg", "secondArg", "thirdArg" }, -- here just as an example
    },
  },
  {
    type = "scala",
    request = "launch",
    name = "Test Target",
    metals = {
      runType = "testTarget",
    },
  },
}

metals_config.on_attach = function(client, bufnr)
  require("metals").setup_dap()
end

-- Autocmd that will actually be in charging of starting the whole thing
local nvim_metals_group = api.nvim_create_augroup("nvim-metals", { clear = true })
api.nvim_create_autocmd("FileType", {
  -- NOTE: You may or may not want java included here. You will need it if you
  -- want basic Java support but it may also conflict if you are using
  -- something like nvim-jdtls which also works on a java filetype autocmd.
  pattern = { "scala", "sbt", "java" },
  callback = function()
    require("metals").initialize_or_attach(metals_config)
  end,
  group = nvim_metals_group,
})



----------------------------------
-- LSP Setup ---------------------
----------------------------------


-- Safe LSP setup: filter mason names, map common aliases, and avoid hard errors
local function safe_setup_lsp()
    if vim.fn.has("nvim-0.11") == 0 then
        vim.notify("Neovim < 0.11 detected — update to 0.11+ for best lspconfig support", vim.log.levels.WARN)
    end

    local ok_zero, lspzero = pcall(require, "lsp-zero")
    if not ok_zero or not lspzero then
        vim.notify("lsp-zero not available, skipping LSP setup", vim.log.levels.WARN)
        return
    end

    -- Desired servers (edit to your preferences)
    local wanted = { "tsserver", "pyright" }

    -- Ensure mason.nvim is initialized before using mason-lspconfig
    local ok_mason_core, mason = pcall(require, "mason")
    if ok_mason_core and mason and type(mason.setup) == "function" then
        local ok, err = pcall(mason.setup)
        if not ok then
            vim.notify(("mason.setup() failed: %s"):format(tostring(err)), vim.log.levels.WARN)
        end
    else
        vim.notify("mason.nvim not available; skipping mason-lspconfig setup", vim.log.levels.WARN)
    end

    local ok_mason, mason_lsp = pcall(require, "mason-lspconfig")
    if not ok_mason or not mason_lsp or type(mason_lsp.get_available_servers) ~= "function" then
        -- fallback: try to configure lsp-zero without mason filtering
        pcall(function() lspzero.setup() end)
        return
    end

    local available = mason_lsp.get_available_servers() or {}

    -- common alias map: map legacy names to mason/lspconfig equivalents
    local alias_map = {
        tsserver = "ts_ls",
        typescript = "ts_ls",
        typescript_language_server = "ts_ls",
    }

    local ensure = {}
    for _, name in ipairs(wanted) do
        if vim.tbl_contains(available, name) then
            table.insert(ensure, name)
        else
            local alias = alias_map[name]
            if alias and vim.tbl_contains(available, alias) then
                table.insert(ensure, alias)
            else
                vim.notify(("mason-lspconfig: skipping unknown server '%s'"):format(name), vim.log.levels.WARN)
            end
        end
    end

    mason_lsp.setup({
        ensure_installed = ensure,
        automatic_installation = true,
    })

    -- run lsp-zero setup guarded to avoid hard errors from older plugin versions
    local ok_setup, err = pcall(function()
        -- lsp-zero v2+: .preset() was removed (see lsp-zero docs).
        -- Use setup() directly; add options here if you need custom behavior.
        if type(lspzero.setup) == "function" then
            lspzero.setup()
        end
    end)
    if not ok_setup then
        vim.notify(("lsp-zero setup failed: %s"):format(tostring(err)), vim.log.levels.ERROR)
    end
end

-- run safely after startup or after Packer finishes
local aug = vim.api.nvim_create_augroup("elrafa_lsp_setup", { clear = true })
vim.api.nvim_create_autocmd("VimEnter", {
  group = aug,
  once = true,
  callback = safe_setup_lsp,
})
vim.api.nvim_create_autocmd("User", {
  pattern = "PackerComplete",
  group = aug,
  once = true,
  callback = safe_setup_lsp,
})

vim.diagnostic.config({
    virtual_text = true
})

