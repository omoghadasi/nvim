return {
	"nvim-neo-tree/neo-tree.nvim",
	branch = "v3.x",
	dependencies = {
		"nvim-lua/plenary.nvim",
		"nvim-tree/nvim-web-devicons", -- not strictly required, but recommended
		"MunifTanjim/nui.nvim",
	},
	config = function()
		vim.fn.sign_define("DiagnosticSignError", { text = " ", texthl = "DiagnosticSignError" })
		vim.fn.sign_define("DiagnosticSignWarn", { text = " ", texthl = "DiagnosticSignWarn" })
		vim.fn.sign_define("DiagnosticSignInfo", { text = " ", texthl = "DiagnosticSignInfo" })
		vim.fn.sign_define("DiagnosticSignHint", { text = "󰌵", texthl = "DiagnosticSignHint" })
		require("neo-tree").setup({
			open_on_setup = true,
			close_if_last_window = true,
			popup_border_style = "rounded",
			enable_git_status = true,
			enable_diagnostics = true,
			filesystem = { follow_current_file = { enabled = true }, hijack_netrw = true },
			source_selector = {
				winbar = true,
				statusline = true,
			},
		})
		-- vim.keymap.set("n", "<C-E>", ":Neotree filesystem reveal left toggle<CR>")
		vim.keymap.set("n", "<C-E>", ":Neotree focus<CR>",{ noremap = true, silent = true })
	end,
}
