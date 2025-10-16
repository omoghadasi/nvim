return {
	-- ============ Fugitive: Git Commands ============
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
			{ "<leader>gR", "<cmd>Gread<cr>", desc = "Git Read (checkout)" },
		},
	},

	-- ============ Gitsigns: Git Decorations & Hunk Actions ============
	{
		"lewis6991/gitsigns.nvim",
		event = { "BufReadPre", "BufNewFile" },
		opts = {
			signs = {
				add = { text = "│" },
				change = { text = "│" },
				delete = { text = "_" },
				topdelete = { text = "‾" },
				changedelete = { text = "~" },
				untracked = { text = "┆" },
			},
			signcolumn = true,
			numhl = false,
			linehl = false,
			word_diff = false,
			current_line_blame = true,
			current_line_blame_opts = {
				virt_text = true,
				virt_text_pos = "eol",
				delay = 500,
				ignore_whitespace = false,
			},
			current_line_blame_formatter = "<author>, <author_time:%Y-%m-%d> - <summary>",
			watch_gitdir = {
				interval = 1000,
				follow_files = true,
			},
			attach_to_untracked = true,
			sign_priority = 6,
			update_debounce = 100,
			status_formatter = nil,
			max_file_length = 40000,
			preview_config = {
				border = "rounded",
				style = "minimal",
				relative = "cursor",
				row = 0,
				col = 1,
			},
		},
		config = function(_, opts)
			local gitsigns = require("gitsigns")
			gitsigns.setup(opts)

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

			-- Integration با which-key
			local wk_ok, wk = pcall(require, "which-key")
			if wk_ok then
				wk.add({
					{ "<leader>h", group = " Hunks", icon = "" },
					{ "<leader>ht", group = " Toggle", icon = "" },
				})
			end
		end,
	},

	-- ============ Git Conflict ============
	{
		"akinsho/git-conflict.nvim",
		version = "*",
		event = "BufReadPre",
		config = function()
			require("git-conflict").setup({
				default_mappings = {
					ours = "co",
					theirs = "ct",
					none = "c0",
					both = "cb",
					next = "]x",
					prev = "[x",
				},
				default_commands = true,
				disable_diagnostics = true,
				list_opener = "copen",
				highlights = {
					incoming = "DiffAdd",
					current = "DiffText",
				},
			})

			-- Keymaps اضافی با leader
			vim.keymap.set("n", "<leader>co", "<cmd>GitConflictChooseOurs<cr>", { desc = "Choose Ours" })
			vim.keymap.set("n", "<leader>ct", "<cmd>GitConflictChooseTheirs<cr>", { desc = "Choose Theirs" })
			vim.keymap.set("n", "<leader>cb", "<cmd>GitConflictChooseBoth<cr>", { desc = "Choose Both" })
			vim.keymap.set("n", "<leader>c0", "<cmd>GitConflictChooseNone<cr>", { desc = "Choose None" })
			vim.keymap.set("n", "<leader>cn", "<cmd>GitConflictNextConflict<cr>", { desc = "Next Conflict" })
			vim.keymap.set("n", "<leader>cp", "<cmd>GitConflictPrevConflict<cr>", { desc = "Prev Conflict" })
			vim.keymap.set("n", "<leader>cq", "<cmd>GitConflictListQf<cr>", { desc = "List Conflicts" })

			-- Integration با which-key
			local wk_ok, wk = pcall(require, "which-key")
			if wk_ok then
				wk.add({
					{ "<leader>c", group = "⚔️ Conflicts", icon = "" },
					{ "co", desc = "Choose Ours" },
					{ "ct", desc = "Choose Theirs" },
					{ "cb", desc = "Choose Both" },
					{ "c0", desc = "Choose None" },
					{ "]x", desc = "Next Conflict" },
					{ "[x", desc = "Prev Conflict" },
				})
			end
		end,
	},

	-- ============ Diffview ============
	{
		"sindrets/diffview.nvim",
		dependencies = { "nvim-tree/nvim-web-devicons" },
		cmd = { "DiffviewOpen", "DiffviewFileHistory", "DiffviewClose", "DiffviewToggleFiles", "DiffviewFocusFiles" },
		keys = {
			{ "<leader>gd", "<cmd>DiffviewOpen<cr>", desc = "Diffview Open" },
			{ "<leader>gh", "<cmd>DiffviewFileHistory %<cr>", desc = "File History" },
			{ "<leader>gH", "<cmd>DiffviewFileHistory<cr>", desc = "Project History" },
			{ "<leader>gc", "<cmd>DiffviewClose<cr>", desc = "Close Diffview" },
			{ "<leader>gt", "<cmd>DiffviewToggleFiles<cr>", desc = "Toggle File Panel" },
			{ "<leader>gf", "<cmd>DiffviewFocusFiles<cr>", desc = "Focus File Panel" },
			{ "<leader>gr", "<cmd>DiffviewRefresh<cr>", desc = "Refresh Diffview" },
		},
		config = function()
			local actions = require("diffview.actions")

			require("diffview").setup({
				diff_binaries = false,
				enhanced_diff_hl = true,
				git_cmd = { "git" },
				hg_cmd = { "hg" },
				use_icons = true,
				show_help_hints = true,
				watch_index = true,

				icons = {
					folder_closed = "",
					folder_open = "",
				},
				signs = {
					fold_closed = "",
					fold_open = "",
					done = "✓",
				},

				view = {
					default = {
						layout = "diff2_horizontal",
						disable_diagnostics = true,
						winbar_info = false,
					},
					merge_tool = {
						layout = "diff3_horizontal",
						disable_diagnostics = true,
						winbar_info = true,
					},
					file_history = {
						layout = "diff2_horizontal",
						disable_diagnostics = true,
						winbar_info = false,
					},
				},

				file_panel = {
					listing_style = "tree",
					tree_options = {
						flatten_dirs = true,
						folder_statuses = "only_folded",
					},
					win_config = {
						position = "left",
						width = 35,
						height = 10,
						win_opts = {
							winhl = "Normal:Normal,FloatBorder:Normal",
						},
					},
				},

				file_history_panel = {
					log_options = {
						git = {
							single_file = {
								diff_merges = "combined",
							},
							multi_file = {
								diff_merges = "first-parent",
							},
						},
						hg = {
							single_file = {},
							multi_file = {},
						},
					},
					win_config = {
						position = "bottom",
						height = 16,
						win_opts = {},
					},
				},

				commit_log_panel = {
					win_config = {
						height = 16,
					},
				},

				default_args = {
					DiffviewOpen = {},
					DiffviewFileHistory = {},
				},

				hooks = {
					diff_buf_read = function(bufnr)
						vim.opt_local.wrap = false
						vim.opt_local.list = false
						vim.opt_local.relativenumber = false
						vim.opt_local.cursorline = true
					end,
					view_opened = function(view)
						vim.notify("🔍 Diffview opened!", vim.log.levels.INFO)
					end,
					view_closed = function(view)
						vim.notify("✅ Diffview closed", vim.log.levels.INFO)
					end,
				},

				keymaps = {
					disable_defaults = false,
					view = {
						{ "n", "<tab>", actions.select_next_entry, { desc = "Next file" } },
						{ "n", "<s-tab>", actions.select_prev_entry, { desc = "Previous file" } },
						{ "n", "[F", actions.select_first_entry, { desc = "First file" } },
						{ "n", "]F", actions.select_last_entry, { desc = "Last file" } },
						{ "n", "gf", actions.goto_file_edit, { desc = "Open file" } },
						{ "n", "<C-w><C-f>", actions.goto_file_split, { desc = "Open in split" } },
						{ "n", "<C-w>gf", actions.goto_file_tab, { desc = "Open in tab" } },
						{ "n", "<leader>e", actions.focus_files, { desc = "Focus files" } },
						{ "n", "<leader>b", actions.toggle_files, { desc = "Toggle files" } },
						{ "n", "g<C-x>", actions.cycle_layout, { desc = "Cycle layout" } },
						{ "n", "[x", actions.prev_conflict, { desc = "Prev conflict" } },
						{ "n", "]x", actions.next_conflict, { desc = "Next conflict" } },
						{ "n", "<leader>co", actions.conflict_choose("ours"), { desc = "Choose OURS" } },
						{ "n", "<leader>ct", actions.conflict_choose("theirs"), { desc = "Choose THEIRS" } },
						{ "n", "<leader>cb", actions.conflict_choose("base"), { desc = "Choose BASE" } },
						{ "n", "<leader>ca", actions.conflict_choose("all"), { desc = "Choose ALL" } },
						{ "n", "dx", actions.conflict_choose("none"), { desc = "Delete conflict" } },
						{
							"n",
							"<leader>cO",
							actions.conflict_choose_all("ours"),
							{ desc = "Choose OURS (all)" },
						},
						{
							"n",
							"<leader>cT",
							actions.conflict_choose_all("theirs"),
							{ desc = "Choose THEIRS (all)" },
						},
						{
							"n",
							"<leader>cB",
							actions.conflict_choose_all("base"),
							{ desc = "Choose BASE (all)" },
						},
						{
							"n",
							"<leader>cA",
							actions.conflict_choose_all("all"),
							{ desc = "Choose ALL (all)" },
						},
						{ "n", "dX", actions.conflict_choose_all("none"), { desc = "Delete all conflicts" } },
						{ "n", "q", "<cmd>DiffviewClose<cr>", { desc = "Close" } },
					},
					diff1 = {
						{ "n", "g?", actions.help({ "view", "diff1" }), { desc = "Help" } },
					},
					diff2 = {
						{ "n", "g?", actions.help({ "view", "diff2" }), { desc = "Help" } },
					},
					diff3 = {
						{ { "n", "x" }, "2do", actions.diffget("ours"), { desc = "Get OURS" } },
						{ { "n", "x" }, "3do", actions.diffget("theirs"), { desc = "Get THEIRS" } },
						{ "n", "g?", actions.help({ "view", "diff3" }), { desc = "Help" } },
					},
					diff4 = {
						{ { "n", "x" }, "1do", actions.diffget("base"), { desc = "Get BASE" } },
						{ { "n", "x" }, "2do", actions.diffget("ours"), { desc = "Get OURS" } },
						{ { "n", "x" }, "3do", actions.diffget("theirs"), { desc = "Get THEIRS" } },
						{ "n", "g?", actions.help({ "view", "diff4" }), { desc = "Help" } },
					},
					file_panel = {
						{ "n", "j", actions.next_entry, { desc = "Next" } },
						{ "n", "<down>", actions.next_entry, { desc = "Next" } },
						{ "n", "k", actions.prev_entry, { desc = "Previous" } },
						{ "n", "<up>", actions.prev_entry, { desc = "Previous" } },
						{ "n", "<cr>", actions.select_entry, { desc = "Open" } },
						{ "n", "o", actions.select_entry, { desc = "Open" } },
						{ "n", "l", actions.select_entry, { desc = "Open" } },
						{ "n", "<2-LeftMouse>", actions.select_entry, { desc = "Open" } },
						{ "n", "-", actions.toggle_stage_entry, { desc = "Stage/unstage" } },
						{ "n", "s", actions.toggle_stage_entry, { desc = "Stage/unstage" } },
						{ "n", "S", actions.stage_all, { desc = "Stage all" } },
						{ "n", "U", actions.unstage_all, { desc = "Unstage all" } },
						{ "n", "X", actions.restore_entry, { desc = "Restore" } },
						{ "n", "L", actions.open_commit_log, { desc = "Commit log" } },
						{ "n", "zo", actions.open_fold, { desc = "Open fold" } },
						{ "n", "h", actions.close_fold, { desc = "Close fold" } },
						{ "n", "zc", actions.close_fold, { desc = "Close fold" } },
						{ "n", "za", actions.toggle_fold, { desc = "Toggle fold" } },
						{ "n", "zR", actions.open_all_folds, { desc = "Open all" } },
						{ "n", "zM", actions.close_all_folds, { desc = "Close all" } },
						{ "n", "<c-b>", actions.scroll_view(-0.25), { desc = "Scroll up" } },
						{ "n", "<c-f>", actions.scroll_view(0.25), { desc = "Scroll down" } },
						{ "n", "<tab>", actions.select_next_entry, { desc = "Next file" } },
						{ "n", "<s-tab>", actions.select_prev_entry, { desc = "Prev file" } },
						{ "n", "[F", actions.select_first_entry, { desc = "First file" } },
						{ "n", "]F", actions.select_last_entry, { desc = "Last file" } },
						{ "n", "gf", actions.goto_file_edit, { desc = "Open file" } },
						{ "n", "<C-w><C-f>", actions.goto_file_split, { desc = "Open split" } },
						{ "n", "<C-w>gf", actions.goto_file_tab, { desc = "Open tab" } },
						{ "n", "i", actions.listing_style, { desc = "Toggle list/tree" } },
						{ "n", "f", actions.toggle_flatten_dirs, { desc = "Flatten dirs" } },
						{ "n", "R", actions.refresh_files, { desc = "Refresh" } },
						{ "n", "<leader>e", actions.focus_files, { desc = "Focus files" } },
						{ "n", "<leader>b", actions.toggle_files, { desc = "Toggle files" } },
						{ "n", "g<C-x>", actions.cycle_layout, { desc = "Cycle layout" } },
						{ "n", "[x", actions.prev_conflict, { desc = "Prev conflict" } },
						{ "n", "]x", actions.next_conflict, { desc = "Next conflict" } },
						{ "n", "g?", actions.help("file_panel"), { desc = "Help" } },
						{ "n", "q", "<cmd>DiffviewClose<cr>", { desc = "Close" } },
					},
					file_history_panel = {
						{ "n", "g!", actions.options, { desc = "Options" } },
						{ "n", "<C-A-d>", actions.open_in_diffview, { desc = "Open diffview" } },
						{ "n", "y", actions.copy_hash, { desc = "Copy hash" } },
						{ "n", "L", actions.open_commit_log, { desc = "Commit log" } },
						{ "n", "X", actions.restore_entry, { desc = "Restore" } },
						{ "n", "zo", actions.open_fold, { desc = "Open fold" } },
						{ "n", "zc", actions.close_fold, { desc = "Close fold" } },
						{ "n", "h", actions.close_fold, { desc = "Close fold" } },
						{ "n", "za", actions.toggle_fold, { desc = "Toggle fold" } },
						{ "n", "zR", actions.open_all_folds, { desc = "Open all" } },
						{ "n", "zM", actions.close_all_folds, { desc = "Close all" } },
						{ "n", "j", actions.next_entry, { desc = "Next" } },
						{ "n", "<down>", actions.next_entry, { desc = "Next" } },
						{ "n", "k", actions.prev_entry, { desc = "Previous" } },
						{ "n", "<up>", actions.prev_entry, { desc = "Previous" } },
						{ "n", "<cr>", actions.select_entry, { desc = "Open" } },
						{ "n", "o", actions.select_entry, { desc = "Open" } },
						{ "n", "l", actions.select_entry, { desc = "Open" } },
						{ "n", "<2-LeftMouse>", actions.select_entry, { desc = "Open" } },
						{ "n", "<c-b>", actions.scroll_view(-0.25), { desc = "Scroll up" } },
						{ "n", "<c-f>", actions.scroll_view(0.25), { desc = "Scroll down" } },
						{ "n", "<tab>", actions.select_next_entry, { desc = "Next file" } },
						{ "n", "<s-tab>", actions.select_prev_entry, { desc = "Prev file" } },
						{ "n", "[F", actions.select_first_entry, { desc = "First file" } },
						{ "n", "]F", actions.select_last_entry, { desc = "Last file" } },
						{ "n", "gf", actions.goto_file_edit, { desc = "Open file" } },
						{ "n", "<C-w><C-f>", actions.goto_file_split, { desc = "Open split" } },
						{ "n", "<C-w>gf", actions.goto_file_tab, { desc = "Open tab" } },
						{ "n", "<leader>e", actions.focus_files, { desc = "Focus files" } },
						{ "n", "<leader>b", actions.toggle_files, { desc = "Toggle files" } },
						{ "n", "g<C-x>", actions.cycle_layout, { desc = "Cycle layout" } },
						{ "n", "g?", actions.help("file_history_panel"), { desc = "Help" } },
						{ "n", "q", "<cmd>DiffviewClose<cr>", { desc = "Close" } },
					},
					option_panel = {
						{ "n", "<tab>", actions.select_entry, { desc = "Select" } },
						{ "n", "q", actions.close, { desc = "Close" } },
						{ "n", "g?", actions.help("option_panel"), { desc = "Help" } },
					},
					help_panel = {
						{ "n", "q", actions.close, { desc = "Close" } },
						{ "n", "<esc>", actions.close, { desc = "Close" } },
					},
				},
			})

			-- Integration با which-key
			local wk_ok, wk = pcall(require, "which-key")
			if wk_ok then
				wk.add({
					{ "<leader>g", group = "󰊢 Git", icon = "󰊢" },
				})
			end

			-- تنظیمات بصری
			vim.opt.fillchars:append({ diff = "╱" })

			-- Autocmd
			vim.api.nvim_create_autocmd("FileType", {
				pattern = "DiffviewFiles",
				callback = function()
					vim.opt_local.cursorline = true
					vim.opt_local.wrap = false
				end,
			})
		end,
	},
}
