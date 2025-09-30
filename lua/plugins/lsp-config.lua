return {
  {
    "williamboman/mason.nvim",
    config = function()
      require("mason").setup()
    end,
  },
  -- {
  -- 	"williamboman/mason-lspconfig.nvim",
  -- 	config = function()
  -- require("mason-lspconfig").setup({
  -- 	ensure_installed = {
  -- 		"lua_ls",
  -- 		"ts_ls",
  -- 		"bashls",
  -- 		"cssls",
  -- 		"html",
  -- 		"jsonls",
  -- 		"intelephense",
  -- 		"pyright",
  -- 		"sqlls",
  -- 		"tailwindcss",
  -- 		"lemminx",
  -- 		"volar",
  -- 	},
  -- 	automatic_setup = true,
  -- })
  -- 	end,
  -- },
  {
    "neovim/nvim-lspconfig",
    config = function()
      vim.lsp.enable("lua_ls", {})
      vim.lsp.enable("ts_ls")
      vim.lsp.enable("intelephense")
      vim.lsp.enable("html")
      vim.lsp.enable("cssls")
      vim.lsp.enable("jsonls")
      vim.lsp.enable("tailwindcss")
      vim.lsp.enable("vue_ls")
      vim.lsp.enable("pyright", {
        settings = {
          python = {
            analysis = {
              autoSearchPaths = true,
              diagnosticMode = "openFilesOnly",
              useLibraryCodeForTypes = true,
            },
          },
        },
      })
      vim.keymap.set("n", "K", vim.lsp.buf.hover, {})
      vim.keymap.set("n", "gd", vim.lsp.buf.definition, {})
      vim.keymap.set({ "n", "v" }, "<leader>ca", vim.lsp.buf.code_action, {})
    end,
  },
}
