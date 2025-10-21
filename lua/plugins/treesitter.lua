return {
	"nvim-treesitter/nvim-treesitter",
	build = ":TSUpdate",
	event = { "BufReadPost", "BufNewFile" },
	dependencies = {
		"nvim-treesitter/nvim-treesitter-textobjects",
		"nvim-treesitter/nvim-treesitter-context",
		"windwp/nvim-ts-autotag",
	},
	config = function()
		require("nvim-treesitter.configs").setup({
			-- ============ زبان‌ها ============
			ensure_installed = {
				-- Web
				"html",
				"css",
				"scss",
				"javascript",
				"typescript",
				"tsx",
				"json",
				"jsonc",
				"yaml",
				"toml",
				"xml",
				"vue",
				"svelte",
				-- Programming
				"lua",
				"vim",
				"vimdoc",
				"python",
				"php",
				"rust",
				"go",
				"c",
				"cpp",
				"java",
				"bash",
				"fish",
				-- Markup
				"markdown",
				"markdown_inline",
				"regex",
				"latex",
				-- Config
				"dockerfile",
				"gitignore",
				"gitcommit",
				"git_rebase",
				"diff",
				-- Query
				"sql",
				"graphql",
			},

			-- ============ تنظیمات نصب ============
			auto_install = true, -- نصب خودکار parser وقتی فایل باز میشه
			sync_install = false, -- نصب async
			ignore_install = {}, -- زبان‌هایی که نصب نشن

			-- ============ Highlight ============
			highlight = {
				enable = true,
				disable = function(lang, buf)
					-- غیرفعال در فایل‌های بزرگ
					local max_filesize = 1024 * 1024 -- 1 MB
					local ok, stats = pcall(vim.loop.fs_stat, vim.api.nvim_buf_get_name(buf))
					if ok and stats and stats.size > max_filesize then
						return true
					end
				end,
				additional_vim_regex_highlighting = false,
			},

			-- ============ Indent ============
			indent = {
				enable = true,
				disable = { "python", "yaml" }, -- این زبان‌ها مشکل دارن
			},

			-- ============ Incremental Selection ============
			incremental_selection = {
				enable = true,
				keymaps = {
					init_selection = "<C-space>",
					node_incremental = "<C-space>",
					scope_incremental = "<C-s>",
					node_decremental = "<C-backspace>",
				},
			},

			-- ============ Text Objects ============
			textobjects = {
				select = {
					enable = true,
					lookahead = true, -- جستجوی خودکار به جلو
					keymaps = {
						-- Functions
						["af"] = "@function.outer",
						["if"] = "@function.inner",
						-- Classes
						["ac"] = "@class.outer",
						["ic"] = "@class.inner",
						-- Conditionals
						["ai"] = "@conditional.outer",
						["ii"] = "@conditional.inner",
						-- Loops
						["al"] = "@loop.outer",
						["il"] = "@loop.inner",
						-- Parameters
						["aa"] = "@parameter.outer",
						["ia"] = "@parameter.inner",
						-- Comments
						["a/"] = "@comment.outer",
						["i/"] = "@comment.inner",
						-- Blocks
						["ab"] = "@block.outer",
						["ib"] = "@block.inner",
					},
					selection_modes = {
						["@parameter.outer"] = "v", -- charwise
						["@function.outer"] = "V", -- linewise
						["@class.outer"] = "<c-v>", -- blockwise
					},
					include_surrounding_whitespace = true,
				},

				-- Move between text objects
				move = {
					enable = true,
					set_jumps = true, -- اضافه کردن به jumplist
					goto_next_start = {
						["]f"] = "@function.outer",
						["]c"] = "@class.outer",
						["]a"] = "@parameter.inner",
					},
					goto_next_end = {
						["]F"] = "@function.outer",
						["]C"] = "@class.outer",
						["]A"] = "@parameter.inner",
					},
					goto_previous_start = {
						["[f"] = "@function.outer",
						["[c"] = "@class.outer",
						["[a"] = "@parameter.inner",
					},
					goto_previous_end = {
						["[F"] = "@function.outer",
						["[C"] = "@class.outer",
						["[A"] = "@parameter.inner",
					},
				},
			},

			-- ============ Autotag (HTML/JSX) ============
			autotag = {
				enable = true,
				enable_rename = true,
				enable_close = true,
				enable_close_on_slash = true,
				filetypes = {
					"html",
					"javascript",
					"typescript",
					"javascriptreact",
					"typescriptreact",
					"svelte",
					"vue",
					"tsx",
					"jsx",
					"xml",
					"markdown",
				},
			},

			-- ============ Playground (Debug) ============
			playground = {
				enable = false,
				updatetime = 25,
				persist_queries = false,
			},

			-- ============ Query Linter ============
			query_linter = {
				enable = true,
				use_virtual_text = true,
				lint_events = { "BufWrite", "CursorHold" },
			},
		})

		-- ============ Context (Sticky Header) ============
		require("treesitter-context").setup({
			enable = true,
			max_lines = 3,
			min_window_height = 0,
			line_numbers = true,
			multiline_threshold = 1,
			trim_scope = "outer",
			mode = "cursor",
			separator = nil,
			zindex = 20,
		})

		-- ============ Integration با which-key ============
		local wk_ok, wk = pcall(require, "which-key")
		if wk_ok then
			wk.add({
				-- Text objects
				{ mode = { "o", "x" }, "af", desc = "Around Function" },
				{ mode = { "o", "x" }, "if", desc = "Inside Function" },
				{ mode = { "o", "x" }, "ac", desc = "Around Class" },
				{ mode = { "o", "x" }, "ic", desc = "Inside Class" },
				{ mode = { "o", "x" }, "ai", desc = "Around Conditional" },
				{ mode = { "o", "x" }, "ii", desc = "Inside Conditional" },
				{ mode = { "o", "x" }, "al", desc = "Around Loop" },
				{ mode = { "o", "x" }, "il", desc = "Inside Loop" },
				{ mode = { "o", "x" }, "aa", desc = "Around Parameter" },
				{ mode = { "o", "x" }, "ia", desc = "Inside Parameter" },

				-- Move
				{ "]f", desc = "Next Function Start" },
				{ "]F", desc = "Next Function End" },
				{ "[f", desc = "Prev Function Start" },
				{ "[F", desc = "Prev Function End" },
				{ "]c", desc = "Next Class Start" },
				{ "[c", desc = "Prev Class Start" },
			})
		end
	end,
}
