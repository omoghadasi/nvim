return {
	"folke/which-key.nvim",
	event = "VeryLazy",
	init = function()
		vim.o.timeout = true
		vim.o.timeoutlen = 300
	end,
	opts = {
      spec = {
        { "<leader>a", group = "AI" },
        { "<leader>b", group = "Buffer Ordering" },
        { "<leader>f", group = "Find Everything" },
        { "<leader>ff", group = "Find File" },
        { "<leader>fh", group = "Find Help" },
        { "<leader>k", group = "Keymap Finding" },
        { "<leader>s", group = "Search in File" },
        { "<leader>v", group = "Python Venv" },
        { "<leader>x", group = "Trouble Show" },
        { "<leader>t", group = "Toggle Option" },
        { "<leader><leader>", group = "Go to" },
      },
		-- your configuration comes here
		-- or leave it empty to use the default settings
		-- refer to the configuration section below
	},
}
