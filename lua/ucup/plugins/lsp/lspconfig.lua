-- File: ~/.config/nvim/lua/ucup/plugins/lsp/lspconfig.lua
return {
  "neovim/nvim-lspconfig",
  event = { "BufReadPre", "BufNewFile" },
  dependencies = {
    "williamboman/mason.nvim", -- Make sure mason loads first
    "williamboman/mason-lspconfig.nvim", -- Make sure mason-lspconfig loads second
    "hrsh7th/cmp-nvim-lsp",
    { "antosha417/nvim-lsp-file-operations", config = true },
    { "folke/neodev.nvim", opts = {}, lazy = false },
  },
  config = function()
    -- Make sure mason.nvim is loaded and configured first
    local mason_ok, _ = pcall(require, "mason")
    if not mason_ok then
      vim.notify("Mason is not installed!", vim.log.levels.ERROR)
      return
    end

    -- Make sure mason-lspconfig is loaded and configured
    local mason_lspconfig_ok, mason_lspconfig = pcall(require, "mason-lspconfig")
    if not mason_lspconfig_ok then
      vim.notify("Mason-lspconfig is not installed!", vim.log.levels.ERROR)
      return
    end

    local lspconfig = require("lspconfig")
    local cmp_nvim_lsp = require("cmp_nvim_lsp")
    local keymap = vim.keymap

    -- Autocmd yang benar
    vim.api.nvim_create_autocmd("LspAttach", {
      group = vim.api.nvim_create_augroup("userlspconfig", {}),
      callback = function(ev)
        local opts = { buffer = ev.buf, silent = true }

        -- Keymaps yang diperbaiki
        opts.desc = "Show LSP references"
        keymap.set("n", "gr", "<cmd>Telescope lsp_references<CR>", opts)

        opts.desc = "Go to declaration"
        keymap.set("n", "gD", vim.lsp.buf.declaration, opts)

        opts.desc = "Show LSP definitions"
        keymap.set("n", "gd", "<cmd>Telescope lsp_definitions<CR>", opts)

        opts.desc = "Show LSP implementations"
        keymap.set("n", "gi", "<cmd>Telescope lsp_implementations<CR>", opts)

        opts.desc = "Show LSP type definitions"
        keymap.set("n", "gt", "<cmd>Telescope lsp_type_definitions<CR>", opts)

        opts.desc = "Code actions"
        keymap.set({ "n", "v" }, "<leader>ca", vim.lsp.buf.code_action, opts)

        opts.desc = "Smart rename"
        keymap.set("n", "<leader>rn", vim.lsp.buf.rename, opts)

        opts.desc = "Show file diagnostics"
        keymap.set("n", "<leader>dd", "<cmd>Telescope diagnostics bufnr=0<CR>", opts)

        opts.desc = "Show line diagnostics"
        keymap.set("n", "<leader>dl", vim.diagnostic.open_float, opts)

        opts.desc = "Previous diagnostic"
        keymap.set("n", "[d", vim.diagnostic.goto_prev, opts)

        opts.desc = "Next diagnostic"
        keymap.set("n", "]d", vim.diagnostic.goto_next, opts)

        opts.desc = "Documentation hover"
        keymap.set("n", "K", vim.lsp.buf.hover, opts)

        opts.desc = "Restart LSP"
        keymap.set("n", "<leader>rs", ":LspRestart<CR>", opts)
      end,
    })

    local capabilities = cmp_nvim_lsp.default_capabilities()

    -- Konfigurasi tanda diagnostik
    local signs = { Error = " ", Warn = " ", Hint = "󰠠 ", Info = " " }
    for type, icon in pairs(signs) do
      local hl = "DiagnosticSign" .. type
      vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = "" })
    end

    -- Set up individual servers
    -- Common setup for most servers
    local servers = mason_lspconfig.get_installed_servers()

    for _, server in ipairs(servers) do
      -- Special setup for specific servers
      if server == "svelte" then
        lspconfig.svelte.setup({
          capabilities = capabilities,
          on_attach = function(client, bufnr)
            vim.api.nvim_create_autocmd("BufWritePost", {
              pattern = { "*.js", "*.ts" },
              callback = function(ctx)
                client.notify("$/onDidChangeTsOrJsFile", { uri = ctx.file })
              end,
            })
          end,
        })
      elseif server == "lua_ls" then
        lspconfig.lua_ls.setup({
          capabilities = capabilities,
          settings = {
            Lua = {
              runtime = { version = "LuaJIT" },
              workspace = { checkThirdParty = false },
              telemetry = { enable = false },
              diagnostics = { globals = { "vim" } },
              completion = { callSnippet = "Replace" },
            },
          },
        })
      else
        -- Default setup for other servers
        lspconfig[server].setup({
          capabilities = capabilities,
        })
      end
    end
  end,
}
