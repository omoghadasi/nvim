return {
	{
		"tpope/vim-fugitive",
		cmd = { "G", "Git", "Gdiffsplit", "Gvdiffsplit", "Gread", "Gwrite", "Ggrep", "GMove", "GDelete", "GBrowse" },
		keys = {
			{ "<leader>gs", "<cmd>Git<cr>", desc = "Git Status" },
			{ "<leader>gC", "<cmd>Git commit<cr>", desc = "Git Commit" },
			{ "<leader>gp", "<cmd>Git push<cr>", desc = "Git Push" },
			{ "<leader>gP", "<cmd>Git pull<cr>", desc = "Git Pull" },
			{ "<leader>gb", "<cmd>Git blame<cr>", desc = "Git Blame" },
			{ "<leader>gL", "<cmd>Git log<cr>", desc = "Git Log" },
			{ "<leader>gw", "<cmd>Gwrite<cr>", desc = "Git Write (stage)" },
			{ "<leader>gr", "<cmd>Gread<cr>", desc = "Git Read (checkout)" },
		},
	},

	-- ============ Gitsigns: Git Decorations & Hunk Actions ============
	{
		"lewis6991/gitsigns.nvim",
		event = { "BufReadPre", "BufNewFile" },
		opts = {
			-- ============ نمایش Signs در Gutter ============
			signs = {
				add = { text = "│" }, -- یا "▎" یا "┃"
				change = { text = "│" },
				delete = { text = "_" },
				topdelete = { text = "‾" },
				changedelete = { text = "~" },
				untracked = { text = "┆" },
			},

			-- ============ Signs در شماره خط ============
			signcolumn = true, -- نمایش signs در ستون سمت چپ
			numhl = false, -- رنگ‌آمیزی شماره خط
			linehl = false, -- رنگ‌آمیزی کل خط
			word_diff = false, -- نمایش تفاوت کلمه به کلمه

			-- ============ Current Line Blame ============
			current_line_blame = true, -- نمایش blame در انتهای خط فعلی
			current_line_blame_opts = {
				virt_text = true,
				virt_text_pos = "eol", -- end of line
				delay = 500, -- تاخیر نمایش (میلی‌ثانیه)
				ignore_whitespace = false,
			},
			current_line_blame_formatter = "<author>, <author_time:%Y-%m-%d> - <summary>",

			-- ============ Watch GitDir ============
			watch_gitdir = {
				interval = 1000, -- چک کردن هر 1 ثانیه
				follow_files = true,
			},

			-- ============ Attach to Untracked Files ============
			attach_to_untracked = true,

			-- ============ Sign Priority ============
			sign_priority = 6,

			-- ============ Update Debounce ============
			update_debounce = 100, -- میلی‌ثانیه

			-- ============ Status Formatter ============
			status_formatter = nil, -- استفاده از فرمت پیش‌فرض

			-- ============ Max File Length ============
			max_file_length = 40000, -- غیرفعال کردن برای فایل‌های بزرگ

			-- ============ Preview Config ============
			preview_config = {
				border = "rounded", -- "single", "double", "rounded", "solid", "shadow"
				style = "minimal",
				relative = "cursor",
				row = 0,
				col = 1,
			},
		},

		config = function(_, opts)
			local gitsigns = require("gitsigns")
			gitsigns.setup(opts)

			-- ============ Keymaps ============
			-- Navigation بین hunks
			vim.keymap.set("n", "]h", function()
				if vim.wo.diff then
					return "]c"
				end
				vim.schedule(function()
					gitsigns.next_hunk()
				end)
				return "<Ignore>"
			end, { expr = true, desc = "Next Hunk" })

			vim.keymap.set("n", "[h", function()
				if vim.wo.diff then
					return "[c"
				end
				vim.schedule(function()
					gitsigns.prev_hunk()
				end)
				return "<Ignore>"
			end, { expr = true, desc = "Previous Hunk" })

			-- Hunk actions
			vim.keymap.set("n", "<leader>hs", gitsigns.stage_hunk, { desc = "Stage Hunk" })
			vim.keymap.set("n", "<leader>hr", gitsigns.reset_hunk, { desc = "Reset Hunk" })
			vim.keymap.set("v", "<leader>hs", function()
				gitsigns.stage_hunk({ vim.fn.line("."), vim.fn.line("v") })
			end, { desc = "Stage Hunk (visual)" })
			vim.keymap.set("v", "<leader>hr", function()
				gitsigns.reset_hunk({ vim.fn.line("."), vim.fn.line("v") })
			end, { desc = "Reset Hunk (visual)" })

			-- Buffer actions
			vim.keymap.set("n", "<leader>hS", gitsigns.stage_buffer, { desc = "Stage Buffer" })
			vim.keymap.set("n", "<leader>hu", gitsigns.undo_stage_hunk, { desc = "Undo Stage Hunk" })
			vim.keymap.set("n", "<leader>hR", gitsigns.reset_buffer, { desc = "Reset Buffer" })

			-- Preview & Blame
			vim.keymap.set("n", "<leader>hp", gitsigns.preview_hunk, { desc = "Preview Hunk" })
			vim.keymap.set("n", "<leader>hb", function()
				gitsigns.blame_line({ full = true })
			end, { desc = "Blame Line (full)" })
			vim.keymap.set("n", "<leader>hB", gitsigns.toggle_current_line_blame, { desc = "Toggle Line Blame" })

			-- Diff
			vim.keymap.set("n", "<leader>hd", gitsigns.diffthis, { desc = "Diff This" })
			vim.keymap.set("n", "<leader>hD", function()
				gitsigns.diffthis("~")
			end, { desc = "Diff This ~" })

			-- Toggle
			vim.keymap.set("n", "<leader>htd", gitsigns.toggle_deleted, { desc = "Toggle Deleted" })
			vim.keymap.set("n", "<leader>htw", gitsigns.toggle_word_diff, { desc = "Toggle Word Diff" })
			vim.keymap.set("n", "<leader>hts", gitsigns.toggle_signs, { desc = "Toggle Signs" })
			vim.keymap.set("n", "<leader>htn", gitsigns.toggle_numhl, { desc = "Toggle Number HL" })
			vim.keymap.set("n", "<leader>htl", gitsigns.toggle_linehl, { desc = "Toggle Line HL" })

			-- Text object
			vim.keymap.set({ "o", "x" }, "ih", ":<C-U>Gitsigns select_hunk<CR>", { desc = "Select Hunk" })

			-- ============ Integration با which-key ============
			local wk_ok, wk = pcall(require, "which-key")
			if wk_ok then
				wk.add({
					{ "<leader>h", group = " Hunks", icon = "" },
					{ "<leader>ht", group = " Toggle", icon = "" },
				})
			end
		end,
	},
	{
		"akinsho/git-conflict.nvim",
		version = "*",
		event = "BufReadPre",
		config = function()
			require("git-conflict").setup({
				default_mappings = true, -- disable this if you want to use your own mappings
				default_commands = true,
				disable_diagnostics = true, -- خاموش کردن diagnostics در conflict
				list_opener = "copen", -- command to open quickfix list
				highlights = {
					incoming = "DiffAdd",
					current = "DiffText",
				},
			})

			-- Integration با which-key
			local wk_ok, wk = pcall(require, "which-key")
			if wk_ok then
				wk.add({
					{ "<leader>c", group = "⚔️ Conflicts", icon = "" },
					{ "<leader>co", "<cmd>GitConflictChooseOurs<cr>", desc = "Choose Ours" },
					{ "<leader>ct", "<cmd>GitConflictChooseTheirs<cr>", desc = "Choose Theirs" },
					{ "<leader>cb", "<cmd>GitConflictChooseBoth<cr>", desc = "Choose Both" },
					{ "<leader>c0", "<cmd>GitConflictChooseNone<cr>", desc = "Choose None" },
					{ "<leader>cn", "<cmd>GitConflictNextConflict<cr>", desc = "Next Conflict" },
					{ "<leader>cp", "<cmd>GitConflictPrevConflict<cr>", desc = "Prev Conflict" },
					{ "<leader>cl", "<cmd>GitConflictListQf<cr>", desc = "List Conflicts" },
				})
			end
		end,
	},
}
