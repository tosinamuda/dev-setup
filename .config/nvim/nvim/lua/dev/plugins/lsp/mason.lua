return {
  "williamboman/mason.nvim",
  build = ":MasonUpdate",                        -- optional: auto-update registry
  dependencies = {
    "williamboman/mason-lspconfig.nvim",         -- (loaded but configured elsewhere)
    "WhoIsSethDaniel/mason-tool-installer.nvim",
  },

  config = function()
    ----------------------------------------------------------------
    --  Mason core
    ----------------------------------------------------------------
    require("mason").setup({
      ui = {
        icons = {
          package_installed   = "✓",
          package_pending     = "➜",
          package_uninstalled = "✗",
        },
      },
    })

    ----------------------------------------------------------------
    --  Formatters / linters / DAP via mason-tool-installer
    ----------------------------------------------------------------
    require("mason-tool-installer").setup({
      ensure_installed = {
        -- formatters
        "prettier",
        "stylua",
        "isort",
        "black",

        -- linters
        "pylint",
        "eslint-lsp",
        "eslint_d",
      },
      auto_update = false,   -- set true if you want it to pull latest every start
      run_on_start = true,
    })
  end,
}
