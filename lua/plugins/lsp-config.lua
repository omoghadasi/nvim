return {
	{
		"williamboman/mason.nvim",
		config = function()
			require("mason").setup()
		end,
	},
	{
		"williamboman/mason-lspconfig.nvim",
		config = function()
			require("mason-lspconfig").setup({
				ensure_installed = {
					"lua_ls",
					"ts_ls",
					"bashls",
					"cssls",
					"html",
					"jsonls",
					"intelephense",
					"pyright",
					"sqlls",
					"tailwindcss",
					"lemminx",
				},
				automatic_setup = true,
			})
			vim.diagnostic.config({
				virtual_text = {
					spacing = 2,
          source = true
				},
				signs = true,
				underline = false,
				update_in_insert = true,
        severity_sort = true
			})
		end,
	},
	{
		"neovim/nvim-lspconfig",
		config = function()
			local vue_language_server_path = vim.fn.expand("$MASON/packages")
				.. "/vue-language-server"
				.. "/node_modules/@vue/language-server"
			local vue_plugin = {
				name = "@vue/typescript-plugin",
				location = vue_language_server_path,
				languages = { "vue" },
				configNamespace = "typescript",
			}
			vim.lsp.config("vtsls", {
				settings = {
					vtsls = {
						tsserver = {
							globalPlugins = {
								vue_plugin,
							},
						},
					},
				},
				filetypes = { "typescript", "javascript", "javascriptreact", "typescriptreact", "vue" },
			})
			vim.lsp.enable("ts_ls")
			vim.lsp.enable("vue_ls")
			vim.lsp.enable("vtsls")
			vim.lsp.enable("lua_ls")
			vim.lsp.enable("intelephense")
			vim.lsp.enable("html")
			vim.lsp.enable("cssls")
			vim.lsp.enable("jsonls")
			vim.lsp.enable("tailwindcss")
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
