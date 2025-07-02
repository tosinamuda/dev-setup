return {
  "neovim/nvim-lspconfig",
  event = { "BufReadPre", "BufNewFile" },
  dependencies = {
    { "williamboman/mason.nvim",               config = true },  -- must load first
    "williamboman/mason-lspconfig.nvim",                           -- we configure it below
    "hrsh7th/cmp-nvim-lsp",
    { "antosha417/nvim-lsp-file-operations",   config = true },
    { "folke/neodev.nvim",                     opts = {} },
  },

  config = function()
    ----------------------------------------------------------------
    --  Helpers
    ----------------------------------------------------------------
    local lspconfig    = require("lspconfig")
    local mason_lsp    = require("mason-lspconfig")
    local cmp_nvim_lsp = require("cmp_nvim_lsp")
    local keymap       = vim.keymap
    local capabilities = cmp_nvim_lsp.default_capabilities()

    ----------------------------------------------------------------
    --  Signs
    ----------------------------------------------------------------
    for type, icon in pairs({ Error = " ", Warn = " ", Hint = "󰠠 ", Info = " " }) do
      vim.fn.sign_define("DiagnosticSign" .. type, { text = icon, texthl = "", numhl = "" })
    end

    ----------------------------------------------------------------
    --  Buffer-local key-maps (fires once per attached server)
    ----------------------------------------------------------------
    vim.api.nvim_create_autocmd("LspAttach", {
      group = vim.api.nvim_create_augroup("UserLspConfig", {}),
      callback = function(ev)
        local opts = { buffer = ev.buf, silent = true }

        keymap.set("n", "gR",               "<cmd>Telescope lsp_references<CR>",         vim.tbl_extend("force", opts, { desc = "References" }))
        keymap.set("n", "gD",               vim.lsp.buf.declaration,                     vim.tbl_extend("force", opts, { desc = "Declaration" }))
        keymap.set("n", "gd",               "<cmd>Telescope lsp_definitions<CR>",        vim.tbl_extend("force", opts, { desc = "Definitions" }))
        keymap.set("n", "gi",               "<cmd>Telescope lsp_implementations<CR>",    vim.tbl_extend("force", opts, { desc = "Implementations" }))
        keymap.set("n", "gt",               "<cmd>Telescope lsp_type_definitions<CR>",   vim.tbl_extend("force", opts, { desc = "Type definitions" }))
        keymap.set({ "n", "v" }, "<leader>ca", vim.lsp.buf.code_action,                  vim.tbl_extend("force", opts, { desc = "Code action" }))
        keymap.set("n", "<leader>rn",        vim.lsp.buf.rename,                         vim.tbl_extend("force", opts, { desc = "Rename" }))
        keymap.set("n", "<leader>D",        "<cmd>Telescope diagnostics bufnr=0<CR>",    vim.tbl_extend("force", opts, { desc = "Buffer diagnostics" }))
        keymap.set("n", "<leader>d",        vim.diagnostic.open_float,                   vim.tbl_extend("force", opts, { desc = "Line diagnostics" }))
        keymap.set("n", "[d",               vim.diagnostic.goto_prev,                    vim.tbl_extend("force", opts, { desc = "Prev diagnostic" }))
        keymap.set("n", "]d",               vim.diagnostic.goto_next,                    vim.tbl_extend("force", opts, { desc = "Next diagnostic" }))
        keymap.set("n", "K",                vim.lsp.buf.hover,                           vim.tbl_extend("force", opts, { desc = "Hover docs" }))
        keymap.set("n", "<leader>rs",       ":LspRestart<CR>",                           vim.tbl_extend("force", opts, { desc = "Restart LSP" }))
      end,
    })

    ----------------------------------------------------------------
    --  Mason-LSPConfig v2 – once, right here
    ----------------------------------------------------------------
    mason_lsp.setup({
      -- 🗂 what to auto-install
      ensure_installed = {
        "ts_ls",
        "html",
        "cssls",
        "tailwindcss",
        "svelte",
        "lua_ls",
        "graphql",
        "emmet_ls",
        "prismals",
        "pyright",
        "eslint",
      },

      -- 🛠 per-server tweaks
      handlers = vim.tbl_extend("force", {
        -- default handler
        function(server)
          lspconfig[server].setup({ capabilities = capabilities })
        end,
      }, {
        svelte = function()
          lspconfig.svelte.setup({
            capabilities = capabilities,
            on_attach = function(client, _)
              vim.api.nvim_create_autocmd("BufWritePost", {
                pattern = { "*.js", "*.ts" },
                callback = function(ctx)
                  client.notify("$/onDidChangeTsOrJsFile", { uri = ctx.match })
                end,
              })
            end,
          })
        end,

        graphql = function()
          lspconfig.graphql.setup({
            capabilities = capabilities,
            filetypes = { "graphql", "gql", "svelte", "typescriptreact", "javascriptreact" },
          })
        end,

        emmet_ls = function()
          lspconfig.emmet_ls.setup({
            capabilities = capabilities,
            filetypes = { "html", "typescriptreact", "javascriptreact", "css", "sass", "scss", "less", "svelte" },
          })
        end,

        lua_ls = function()
          lspconfig.lua_ls.setup({
            capabilities = capabilities,
            settings = {
              Lua = {
                diagnostics = { globals = { "vim" } },
                completion  = { callSnippet = "Replace" },
              },
            },
          })
        end,
      }),
    })
  end,
}
