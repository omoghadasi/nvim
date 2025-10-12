return {
	{
		"akinsho/toggleterm.nvim",
		version = "*",
		config = function()
			require("toggleterm").setup({
				open_mapping = [[<C-\>]], -- کلید میانبر باز/بستن ترمینال
				direction = "float", -- حالت‌های دیگر: "horizontal" | "vertical" | "tab"
				shade_terminals = true,
				float_opts = { border = "curved" },
			})
			vim.api.nvim_create_user_command("CloseAllTerminals", function()
				local terms = require("toggleterm.terminal").get_all()
				for id, term in pairs(terms) do
					term:shutdown()
				end
				print("All terminals closed")
			end, {})

			-- فقط زمانی این map کار می‌کنه که termfinder بارگذاری شده باشه
			vim.keymap.set("n", "<leader>tl", "<cmd>Telescope termfinder<CR>", { desc = "List terminals" })
			vim.keymap.set("n", "<leader>tn", function()
				local Terminal = require("toggleterm.terminal").Terminal
				local term = Terminal:new({ direction = "float" }) -- یا "horizontal" / "vertical"
				term:toggle()
			end, { desc = "New terminal" })
			vim.keymap.set("n", "<leader>tt", "<cmd>ToggleTerm<CR>", { desc = "Toggle last terminal" })
			vim.keymap.set("n", "<leader>tc", ":CloseAllTerminals<CR>", { desc = "Close all terminals" })
		end,
	},
	{
		"nvim-telescope/telescope.nvim",
		dependencies = { "nvim-lua/plenary.nvim" },
	},
	{
		"tknightz/telescope-termfinder.nvim",
		dependencies = {
			"akinsho/toggleterm.nvim",
			"nvim-telescope/telescope.nvim",
		},
		config = function()
			require("telescope").load_extension("termfinder")
		end,
	},
}
