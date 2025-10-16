return {
	"lukas-reineke/indent-blankline.nvim",
	main = "ibl",
	event = { "BufReadPost", "BufNewFile" },
	opts = {
		-- ============ Indent ============
		indent = {
			char = "│", -- "▏", "▎", "▍", "▌", "▋", "▊", "▉", "█", "│", "┃"
			tab_char = "│",
			highlight = "IblIndent",
			smart_indent_cap = true,
			priority = 1,
		},

		-- ============ Whitespace ============
		whitespace = {
			highlight = "IblWhitespace",
			remove_blankline_trail = true,
		},

		-- ============ Scope ============
		scope = {
			enabled = true,
			char = "│", -- "▎" برای پررنگ‌تر
			show_start = true, -- نمایش خط اول scope
			show_end = true, -- نمایش خط آخر scope
			show_exact_scope = false,
			injected_languages = true,
			highlight = "IblScope",
			priority = 1024,
			include = {
				node_type = {
					["*"] = {
						"argument_list",
						"arguments",
						"assignment_statement",
						"Block",
						"chunk",
						"class",
						"ContainerDecl",
						"dictionary",
						"do_block",
						"do_statement",
						"element",
						"except",
						"FnCallArguments",
						"for",
						"for_statement",
						"function",
						"function_declaration",
						"function_definition",
						"if_statement",
						"IfStatement",
						"import",
						"InitList",
						"list_literal",
						"method",
						"object",
						"ParamDeclList",
						"repeat_statement",
						"selector",
						"SwitchExpr",
						"table",
						"table_constructor",
						"try",
						"tuple",
						"type",
						"var",
						"while",
						"while_statement",
						"with",
					},
				},
			},
			exclude = {
				language = {},
				node_type = {
					["*"] = { "source_file", "program" },
					lua = { "chunk" },
					python = { "module" },
				},
			},
		},

		-- ============ Exclude ============
		exclude = {
			filetypes = {
				"help",
				"alpha",
				"dashboard",
				"neo-tree",
				"Trouble",
				"trouble",
				"lazy",
				"mason",
				"notify",
				"toggleterm",
				"lazyterm",
				"NvimTree",
				"TelescopePrompt",
				"TelescopeResults",
				"oil",
				"",
			},
			buftypes = {
				"terminal",
				"nofile",
				"quickfix",
				"prompt",
			},
		},
	},

	config = function(_, opts)
		require("ibl").setup(opts)

		-- ============ Custom Highlights ============
		local hooks = require("ibl.hooks")

		-- رنگ‌های سفارشی
		hooks.register(hooks.type.HIGHLIGHT_SETUP, function()
			-- Indent عادی (کمرنگ)
			vim.api.nvim_set_hl(0, "IblIndent", { fg = "#3b4261", nocombine = true })

			-- Scope (پررنگ)
			vim.api.nvim_set_hl(0, "IblScope", { fg = "#7aa2f7", nocombine = true })

			-- Whitespace
			vim.api.nvim_set_hl(0, "IblWhitespace", { fg = "#3b4261", nocombine = true })

			-- Rainbow colors (اختیاری)
			vim.api.nvim_set_hl(0, "RainbowRed", { fg = "#E06C75" })
			vim.api.nvim_set_hl(0, "RainbowYellow", { fg = "#E5C07B" })
			vim.api.nvim_set_hl(0, "RainbowBlue", { fg = "#61AFEF" })
			vim.api.nvim_set_hl(0, "RainbowOrange", { fg = "#D19A66" })
			vim.api.nvim_set_hl(0, "RainbowGreen", { fg = "#98C379" })
			vim.api.nvim_set_hl(0, "RainbowViolet", { fg = "#C678DD" })
			vim.api.nvim_set_hl(0, "RainbowCyan", { fg = "#56B6C2" })
		end)

		-- ============ Keymaps ============
		vim.keymap.set("n", "<leader>ti", "<cmd>IBLToggle<cr>", { desc = "Toggle Indent Lines" })
		vim.keymap.set("n", "<leader>tI", "<cmd>IBLToggleScope<cr>", { desc = "Toggle Indent Scope" })

		-- ============ Integration با which-key ============
		local wk_ok, wk = pcall(require, "which-key")
		if wk_ok then
			wk.add({
				{ "<leader>t", group = " Toggle", icon = "" },
			})
		end
	end,
}
