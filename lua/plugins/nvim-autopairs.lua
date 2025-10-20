return {
	"windwp/nvim-autopairs",
	event = "InsertEnter",
	dependencies = { "hrsh7th/nvim-cmp" },
	config = function()
		local autopairs = require("nvim-autopairs")
		local Rule = require("nvim-autopairs.rule")
		local cond = require("nvim-autopairs.conds")

		autopairs.setup({
			check_ts = true,
			ts_config = {
				lua = { "string" },
				javascript = { "template_string" },
				java = false,
			},
			fast_wrap = {
				map = "<C-s>", 
				chars = { "{", "[", "(", '"', "'" },
				pattern = [=[[%'%"%>%]%)%}%,]]=],
				end_key = "$",
				keys = "qwertyuiopzxcvbnmasdfghjkl",
				check_comma = true,
				highlight = "PmenuSel",
				highlight_grey = "LineNr",
			},
			disable_filetype = { "TelescopePrompt", "vim", "spectre_panel" },
			disable_in_macro = false,
			disable_in_visualblock = false,
			disable_in_replace_mode = true,
			ignored_next_char = [=[[%w%%%'%[%"%.%`%$]]=],
			enable_moveright = true,
			enable_check_bracket_line = true,
			enable_afterquote = true,
			enable_bracket_in_quote = true,
			break_undo = true,
			map_bs = true, 
			map_c_h = false,
			map_c_w = false,
			map_cr = true,
		})

		local cmp_autopairs = require("nvim-autopairs.completion.cmp")
		local cmp = require("cmp")
		cmp.event:on("confirm_done", cmp_autopairs.on_confirm_done())

		local brackets = { { "(", ")" }, { "[", "]" }, { "{", "}" } }
		autopairs.add_rules({
			Rule(" ", " "):with_pair(function(opts)
				local pair = opts.line:sub(opts.col - 1, opts.col)
				return vim.tbl_contains({
					brackets[1][1] .. brackets[1][2],
					brackets[2][1] .. brackets[2][2],
					brackets[3][1] .. brackets[3][2],
				}, pair)
			end),
		})

		-- Arrow function
		autopairs.add_rules({
			Rule("%(.*%)%s*=>$", " {  }", { "typescript", "typescriptreact", "javascript", "javascriptreact" })
				:use_regex(true)
				:set_end_pair_length(2),
		})

		-- Markdown code blocks
		autopairs.add_rules({
			Rule("```", "```", { "markdown" }),
		})

		-- Python docstring
		autopairs.add_rules({
			Rule('"""', '"""', "python"),
		})

		vim.keymap.set("i", "<C-e>", function()
			-- اگه Ctrl+e راحت‌تره می‌تونی این رو هم اضافه کنی
			local line = vim.api.nvim_get_current_line()
			local col = vim.api.nvim_win_get_cursor(0)[2]
			local char = line:sub(col, col)
			local next_char = line:sub(col + 1, col + 1)

			-- اگه توی bracket هستی، ببرتت بعد از closing bracket
			local pairs = {
				["("] = ")",
				["["] = "]",
				["{"] = "}",
				['"'] = '"',
				["'"] = "'",
			}

			if pairs[char] then
				return "<Right>"
			end
			return "<C-e>"
		end, { expr = true, noremap = true, silent = true, desc = "Jump over closing bracket" })

		-- ============ Integration با which-key ============
		local wk_ok, wk = pcall(require, "which-key")
		if wk_ok then
			wk.add({
				{ mode = "i", "<C-s>", desc = "Fast Wrap" },
			})
		end
	end,
}
