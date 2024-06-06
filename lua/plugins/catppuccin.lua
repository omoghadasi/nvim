return {
	"catppuccin/nvim",
	name = "catppuccin",
	priority = 1000,
	config = function()
		require("catppuccin").setup({
			styles = { -- Handles the styles of general hi groups (see `:h highlight-args`):
				comments = { "italic" }, -- Change the style of comments
				conditionals = { "italic" ,'bold'},
				loops = {'bold'},
				functions = { "bold" },
				keywords = {'bold'},
				strings = {'bold'},
				variables = { "bold" },
				numbers = {'bold'},
				booleans = {'bold'},
				properties = {'bold'},
				types = {'bold'},
				operators = {'bold'},
				-- miscs = {}, -- Uncomment to turn off hard-coded styles
			},
			integrations = {
				barbar = true,
				mason = true,
				diffview = true,
				neotree = true,
				which_key = true,
			},
		})
		vim.cmd.colorscheme("catppuccin-mocha")
	end,
}
