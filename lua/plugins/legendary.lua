return {
	"mrjones2014/legendary.nvim",
	priority = 10000,
	lazy = false,
	dependencies = {
		"kkharji/sqlite.lua",
		"stevearc/dressing.nvim",
	},
	keys = {
		{ "<leader>h", "<cmd>Legendary<cr>", desc = "🔥 Legendary Help" },
	},
	config = function()
		require("legendary").setup({
			extensions = {
				lazy_nvim = true,
				nvim_tree = true,
				which_key = {

					auto_register = true,

					do_binding = false,

					use_groups = true,
					lazy_nvim = true,
				},
				diffview = true,
				smart_splits = true,
				op_nvim = true,
			},

			scratchpad = {
				view = "float",
				results_view = "float",
				keep_contents = true,
			},

			sort = {
				frecency = {
					db_root = vim.fn.stdpath("data") .. "/legendary/",
					max_timestamps = 10,
				},
				most_recent_first = true,
				user_items = true,
				default_item_group_order = {
					"keymaps",
					"commands",
					"autocmds",
					"functions",
				},
			},
			select_prompt = "Legendary",
			select_opts = {
				width = 0.8,
				height = 0.8,
			},
			formatter = function(item, mode)
				local values = require("legendary.ui.format").default_format(item, mode)
				return values
			end,
			cache_path = vim.fn.stdpath("cache") .. "/legendary/",
			include_builtin = true,
			include_legendary_cmds = true,
			icons = {
				autocmd = "",
				keymap = nil,
				command = "",
				fn = "󰡱",
				itemgroup = "",
			},
		})
		vim.notify("🔥 Legendary loaded successfully!", vim.log.levels.INFO)
	end,
}
