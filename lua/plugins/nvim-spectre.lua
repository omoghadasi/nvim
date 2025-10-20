return {
	"nvim-pack/nvim-spectre",
	dependencies = {
		"nvim-lua/plenary.nvim",
	},
	cmd = "Spectre",
	keys = {
		{
			"<leader>S",
			function()
				require("spectre").toggle()
			end,
			desc = "Toggle Spectre",
		},
		{
			"<leader>sw",
			function()
				require("spectre").open_visual({ select_word = true })
			end,
			desc = "Search current word",
		},
		{
			"<leader>sw",
			mode = "v",
			function()
				require("spectre").open_visual()
			end,
			desc = "Search selection",
		},
		{
			"<leader>sf",
			function()
				require("spectre").open_file_search({ select_word = true })
			end,
			desc = "Search in current file",
		},
	},
	opts = {
		-- ============ تنظیمات اصلی ============
		color_devicons = true,
		open_cmd = "vnew", -- یا "new" برای horizontal
		live_update = false, -- auto update changes
		line_sep_start = "┌-----------------------------------------",
		result_padding = "¦  ",
		line_sep = "└-----------------------------------------",

		-- ============ Highlight ============
		highlight = {
			ui = "String",
			search = "DiffChange",
			replace = "DiffDelete",
		},

		-- ============ Mapping ============
		mapping = {
			["toggle_line"] = {
				map = "dd",
				cmd = "<cmd>lua require('spectre').toggle_line()<CR>",
				desc = "toggle item",
			},
			["enter_file"] = {
				map = "<cr>",
				cmd = "<cmd>lua require('spectre').open_file_search()<CR>",
				desc = "open file",
			},
			["send_to_qf"] = {
				map = "<leader>q",
				cmd = "<cmd>lua require('spectre').send_to_qf()<CR>",
				desc = "send all to quickfix",
			},
			["replace_cmd"] = {
				map = "<leader>c",
				cmd = "<cmd>lua require('spectre').replace_cmd()<CR>",
				desc = "input replace command",
			},
			["show_option_menu"] = {
				map = "<leader>o",
				cmd = "<cmd>lua require('spectre').show_options()<CR>",
				desc = "show options",
			},
			["run_current_replace"] = {
				map = "<leader>rc",
				cmd = "<cmd>lua require('spectre').run_replace({select_item=true})<CR>",
				desc = "replace current line",
			},
			["run_replace"] = {
				map = "<leader>R",
				cmd = "<cmd>lua require('spectre').run_replace()<CR>",
				desc = "replace all",
			},
			["change_view_mode"] = {
				map = "<leader>v",
				cmd = "<cmd>lua require('spectre').change_view()<CR>",
				desc = "change result view mode",
			},
			["change_replace_sed"] = {
				map = "trs",
				cmd = "<cmd>lua require('spectre').change_engine_replace('sed')<CR>",
				desc = "use sed to replace",
			},
			["change_replace_oxi"] = {
				map = "tro",
				cmd = "<cmd>lua require('spectre').change_engine_replace('oxi')<CR>",
				desc = "use oxi to replace",
			},
			["toggle_live_update"] = {
				map = "tu",
				cmd = "<cmd>lua require('spectre').toggle_live_update()<CR>",
				desc = "toggle live update",
			},
			["toggle_ignore_case"] = {
				map = "ti",
				cmd = "<cmd>lua require('spectre').toggle_ignore_case()<CR>",
				desc = "toggle ignore case",
			},
			["toggle_ignore_hidden"] = {
				map = "th",
				cmd = "<cmd>lua require('spectre').toggle_ignore_hidden()<CR>",
				desc = "toggle search hidden",
			},
			["resume_last_search"] = {
				map = "<leader>l",
				cmd = "<cmd>lua require('spectre').resume_last_search()<CR>",
				desc = "resume last search",
			},
		},

		-- ============ Find Options ============
		find_engine = {
			["rg"] = {
				cmd = "rg",
				args = {
					"--color=never",
					"--no-heading",
					"--with-filename",
					"--line-number",
					"--column",
				},
				options = {
					["ignore-case"] = {
						value = "--ignore-case",
						icon = "[I]",
						desc = "ignore case",
					},
					["hidden"] = {
						value = "--hidden",
						desc = "hidden file",
						icon = "[H]",
					},
				},
			},
			["ag"] = {
				cmd = "ag",
				args = {
					"--vimgrep",
					"-s",
				},
				options = {
					["ignore-case"] = {
						value = "-i",
						icon = "[I]",
						desc = "ignore case",
					},
					["hidden"] = {
						value = "--hidden",
						desc = "hidden file",
						icon = "[H]",
					},
				},
			},
		},

		-- ============ Replace Options ============
		replace_engine = {
			["sed"] = {
				cmd = "sed",
				args = nil,
				options = {
					["ignore-case"] = {
						value = "--ignore-case",
						icon = "[I]",
						desc = "ignore case",
					},
				},
			},
			["oxi"] = {
				cmd = "oxi",
				args = {},
				options = {
					["ignore-case"] = {
						value = "i",
						icon = "[I]",
						desc = "ignore case",
					},
				},
			},
		},

		-- ============ Default Options ============
		default = {
			find = {
				cmd = "rg",
				options = { "ignore-case" },
			},
			replace = {
				cmd = "sed",
			},
		},

		-- ============ Replace Vim Cmd ============
		replace_vim_cmd = "cdo",
		is_open_target_win = true,
		is_insert_mode = false,
	},

	config = function(_, opts)
		require("spectre").setup(opts)

		-- ============ Custom Highlights ============
		vim.api.nvim_set_hl(0, "SpectreSearch", { bg = "#3d59a1", fg = "#c0caf5" })
		vim.api.nvim_set_hl(0, "SpectreReplace", { bg = "#f7768e", fg = "#1a1b26" })
		vim.api.nvim_set_hl(0, "SpectreFile", { fg = "#7aa2f7", bold = true })
		vim.api.nvim_set_hl(0, "SpectreDir", { fg = "#bb9af7" })
		vim.api.nvim_set_hl(0, "SpectreBody", { fg = "#c0caf5" })
		vim.api.nvim_set_hl(0, "SpectreBorder", { fg = "#3b4261" })

		-- ============ Integration با which-key ============
		local wk_ok, wk = pcall(require, "which-key")
		if wk_ok then
			wk.add({
				{ "<leader>s", group = " Search/Replace", icon = "" },
				{ "<leader>S", desc = "Toggle Spectre" },
				{ "<leader>sw", desc = "Search Word" },
				{ "<leader>sf", desc = "Search in File" },
			})
		end
	end,
}
