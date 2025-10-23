return {
	{
		"kylechui/nvim-surround",
		version = "*",
		event = "VeryLazy",
		config = function()
			require("nvim-surround").setup({
				-- ============ Keymaps ============
				keymaps = {
					insert = "<C-g>s",
					insert_line = "<C-g>S",
					normal = "ys",
					normal_cur = "yss",
					normal_line = "yS",
					normal_cur_line = "ySS",
					visual = "S",
					visual_line = "gS",
					delete = "ds",
					change = "cs",
					change_line = "cS",
				},

				-- ============ Aliases ============
				aliases = {
					["a"] = ">", -- angle brackets
					["b"] = ")", -- brackets
					["B"] = "}", -- braces
					["r"] = "]", -- square brackets
					["q"] = { '"', "'", "`" }, -- quotes
					["s"] = { "}", "]", ")", ">", '"', "'", "`" }, -- all surrounds
				},

				-- ============ Highlight ============
				highlight = {
					duration = 0, -- 0 = غیرفعال، عدد = میلی‌ثانیه
				},

				-- ============ Move Cursor ============
				move_cursor = "begin", -- "begin" یا "end" یا false

				-- ============ Indent on Add ============
				indent_lines = function(start, stop)
					local b = vim.bo
					-- فقط در زبان‌هایی که indent مهمه
					if vim.tbl_contains({ "python", "yaml" }, b.filetype) then
						return false
					end
					return true
				end,
			})

			local wk_ok, wk = pcall(require, "which-key")
			if wk_ok then
				wk.add({
					-- Normal mode
					{ "ys", desc = "Add surround" },
					{ "yss", desc = "Add surround (line)" },
					{ "yS", desc = "Add surround (with newline)" },
					{ "ySS", desc = "Add surround (line with newline)" },
					{ "ds", desc = "Delete surround" },
					{ "cs", desc = "Change surround" },

					-- Visual mode
					{ mode = "x", "S", desc = "Add surround" },
					{ mode = "x", "gS", desc = "Add surround (with newline)" },
				})
			end
		end,
	},
}
