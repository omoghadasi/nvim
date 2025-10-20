return {
	{
		"nvim-telescope/telescope.nvim",
		tag = "0.1.8",
		dependencies = {
			"nvim-lua/plenary.nvim",
			"nvim-telescope/telescope-live-grep-args.nvim",
			"nvim-telescope/telescope-file-browser.nvim",
			"nvim-telescope/telescope-project.nvim",
			{ "nvim-telescope/telescope-fzf-native.nvim", build = "make" },
		},
		cmd = "Telescope",
		keys = {
			-- Files
			{ "<leader>ff", "<cmd>Telescope find_files<cr>", desc = "Find Files" },
			{ "<leader>fr", "<cmd>Telescope oldfiles<cr>", desc = "Recent Files" },
			{ "<leader>fb", "<cmd>Telescope buffers<cr>", desc = "Buffers" },
			{ "<leader>fc", "<cmd>Telescope find_files cwd=~/.config/nvim<cr>", desc = "Find Config Files" },

			-- Search
			{ "<leader>fg", "<cmd>Telescope live_grep<cr>", desc = "Live Grep" },
			{ "<leader>fw", "<cmd>Telescope grep_string<cr>", desc = "Find Word" },
			{ "<leader>fa", "<cmd>lua require('telescope').extensions.live_grep_args.live_grep_args()<cr>", desc = "Live Grep (Args)" },

			-- LSP
			{ "<leader>fs", "<cmd>Telescope lsp_document_symbols<cr>", desc = "Document Symbols" },
			{ "<leader>fS", "<cmd>Telescope lsp_workspace_symbols<cr>", desc = "Workspace Symbols" },
			{ "<leader>fd", "<cmd>Telescope diagnostics<cr>", desc = "Diagnostics" },
			{ "<leader>fi", "<cmd>Telescope lsp_implementations<cr>", desc = "Implementations" },
			{ "<leader>fR", "<cmd>Telescope lsp_references<cr>", desc = "References" },

			-- Git
			{ "<leader>fgc", "<cmd>Telescope git_commits<cr>", desc = "Git Commits" },
			{ "<leader>fgb", "<cmd>Telescope git_branches<cr>", desc = "Git Branches" },
			{ "<leader>fgs", "<cmd>Telescope git_status<cr>", desc = "Git Status" },
			{ "<leader>fgh", "<cmd>Telescope git_stash<cr>", desc = "Git Stash" },

			-- Other
			{ "<leader>fh", "<cmd>Telescope help_tags<cr>", desc = "Help Tags" },
			{ "<leader>fk", "<cmd>Telescope keymaps<cr>", desc = "Keymaps" },
			{ "<leader>fm", "<cmd>Telescope macros<cr>", desc = "Macros" },
			{ "<leader>fp", "<cmd>Telescope project<cr>", desc = "Projects" },
			{ "<leader>ft", "<cmd>Telescope colorscheme<cr>", desc = "Themes" },
			{ "<leader>fj", "<cmd>Telescope jumplist<cr>", desc = "Jumplist" },
			{ "<leader>fq", "<cmd>Telescope quickfix<cr>", desc = "Quickfix" },
			{ "<leader>fl", "<cmd>Telescope loclist<cr>", desc = "Location List" },
			{ "<leader>fn", "<cmd>Telescope notify<cr>", desc = "Notifications" },

			-- File Browser
			{ "<leader>fe", "<cmd>Telescope file_browser<cr>", desc = "File Browser" },
			{ "<leader>fE", "<cmd>Telescope file_browser path=%:p:h select_buffer=true<cr>", desc = "File Browser (cwd)" },
		},
		config = function()
			local telescope = require("telescope")
			local actions = require("telescope.actions")
			local project_actions = require("telescope._extensions.project.actions")
			local lga_actions = require("telescope-live-grep-args.actions")

			telescope.setup({
				-- ============ Defaults ============
				defaults = {
					prompt_prefix = "   ",
					selection_caret = " ",
					entry_prefix = "  ",
					multi_icon = "󰄵",

					-- ============ Layout ============
					layout_strategy = "horizontal",
					layout_config = {
						horizontal = {
							prompt_position = "top",
							preview_width = 0.55,
							results_width = 0.8,
						},
						vertical = {
							mirror = false,
						},
						width = 0.87,
						height = 0.80,
						preview_cutoff = 120,
					},

					-- ============ Sorting ============
					sorting_strategy = "ascending",
					selection_strategy = "reset",
					scroll_strategy = "cycle",

					-- ============ Files ============
					file_ignore_patterns = {
						"node_modules",
						".git/",
						"dist/",
						"build/",
						"target/",
						"vendor/",
						"%.lock",
						"__pycache__",
						"%.pyc",
						"%.min.js",
					},

					-- ============ Appearance ============
					border = true,
					borderchars = { "─", "│", "─", "│", "┌", "┐", "┘", "└" },
					color_devicons = true,
					set_env = { ["COLORTERM"] = "truecolor" },

					-- ============ Performance ============
					path_display = { "truncate" },
					dynamic_preview_title = true,

					-- ============ Mappings ============
					mappings = {
						i = {
							-- Navigation
							["<C-j>"] = actions.move_selection_next,
							["<C-k>"] = actions.move_selection_previous,
							["<C-n>"] = actions.cycle_history_next,
							["<C-p>"] = actions.cycle_history_prev,

							-- Selection
							["<CR>"] = actions.select_default,
							["<C-x>"] = actions.select_horizontal,
							["<C-v>"] = actions.select_vertical,
							["<C-t>"] = actions.select_tab,

							-- Preview
							["<C-u>"] = actions.preview_scrolling_up,
							["<C-d>"] = actions.preview_scrolling_down,

							-- Multi-select
							["<Tab>"] = actions.toggle_selection + actions.move_selection_worse,
							["<S-Tab>"] = actions.toggle_selection + actions.move_selection_better,
							["<C-q>"] = actions.send_to_qflist + actions.open_qflist,
							["<M-q>"] = actions.send_selected_to_qflist + actions.open_qflist,

							-- Close
							["<C-c>"] = actions.close,
							["<Esc>"] = actions.close,

							-- History
							["<Down>"] = actions.cycle_history_next,
							["<Up>"] = actions.cycle_history_prev,

							-- Which key
							["<C-/>"] = actions.which_key,
						},
						n = {
							-- Navigation
							["j"] = actions.move_selection_next,
							["k"] = actions.move_selection_previous,
							["H"] = actions.move_to_top,
							["M"] = actions.move_to_middle,
							["L"] = actions.move_to_bottom,

							-- Selection
							["<CR>"] = actions.select_default,
							["<C-x>"] = actions.select_horizontal,
							["<C-v>"] = actions.select_vertical,
							["<C-t>"] = actions.select_tab,

							-- Preview
							["<C-u>"] = actions.preview_scrolling_up,
							["<C-d>"] = actions.preview_scrolling_down,

							-- Multi-select
							["<Tab>"] = actions.toggle_selection + actions.move_selection_worse,
							["<S-Tab>"] = actions.toggle_selection + actions.move_selection_better,
							["<C-q>"] = actions.send_to_qflist + actions.open_qflist,
							["<M-q>"] = actions.send_selected_to_qflist + actions.open_qflist,

							-- Close
							["q"] = actions.close,
							["<Esc>"] = actions.close,

							-- Scroll
							["gg"] = actions.move_to_top,
							["G"] = actions.move_to_bottom,

							-- Which key
							["?"] = actions.which_key,
						},
					},

					-- ============ Vimgrep Arguments ============
					vimgrep_arguments = {
						"rg",
						"--color=never",
						"--no-heading",
						"--with-filename",
						"--line-number",
						"--column",
						"--smart-case",
						"--hidden",
						"--glob",
						"!**/.git/*",
					},
				},

				-- ============ Pickers ============
				pickers = {
					find_files = {
						theme = "dropdown",
						previewer = false,
						hidden = true,
						find_command = { "rg", "--files", "--hidden", "--glob", "!**/.git/*" },
					},
					oldfiles = {
						theme = "dropdown",
						previewer = false,
					},
					buffers = {
						theme = "dropdown",
						previewer = false,
						initial_mode = "normal",
						mappings = {
							i = {
								["<C-d>"] = actions.delete_buffer,
							},
							n = {
								["dd"] = actions.delete_buffer,
							},
						},
					},
					live_grep = {
						theme = "ivy",
					},
					grep_string = {
						theme = "ivy",
					},
					help_tags = {
						theme = "ivy",
					},
					colorscheme = {
						enable_preview = true,
					},
					git_commits = {
						theme = "ivy",
					},
					git_branches = {
						theme = "ivy",
					},
					git_status = {
						theme = "ivy",
					},
					lsp_references = {
						theme = "ivy",
						initial_mode = "normal",
					},
					lsp_definitions = {
						theme = "ivy",
						initial_mode = "normal",
					},
					lsp_implementations = {
						theme = "ivy",
						initial_mode = "normal",
					},
					diagnostics = {
						theme = "ivy",
						initial_mode = "normal",
					},
				},

				-- ============ Extensions ============
				extensions = {
					-- FZF Native
					fzf = {
						fuzzy = true,
						override_generic_sorter = true,
						override_file_sorter = true,
						case_mode = "smart_case",
					},

					-- Live Grep Args
					live_grep_args = {
						auto_quoting = true,
						mappings = {
							i = {
								["<C-k>"] = lga_actions.quote_prompt(),
								["<C-i>"] = lga_actions.quote_prompt({ postfix = " --iglob " }),
								["<C-space>"] = actions.to_fuzzy_refine,
							},
						},
					},

					-- File Browser
					file_browser = {
						theme = "ivy",
						hijack_netrw = true,
						hidden = true,
						respect_gitignore = false,
						grouped = true,
						previewer = false,
						initial_mode = "normal",
						layout_config = { height = 40 },
					},

					-- Project
					project = {
						hidden_files = true,
						theme = "dropdown",
						order_by = "recent",
						search_by = "title",
						sync_with_nvim_tree = true,
						on_project_selected = function(prompt_bufnr)
							project_actions.change_working_directory(prompt_bufnr, false)
							require("telescope.builtin").find_files()
						end,
					},
				},
			})

			-- ============ Load Extensions ============
			telescope.load_extension("fzf")
			telescope.load_extension("live_grep_args")
			telescope.load_extension("file_browser")
			telescope.load_extension("project")
			telescope.load_extension("macros")
			telescope.load_extension("notify") -- اگه nvim-notify داری

			-- ============ Integration با which-key ============
			local wk_ok, wk = pcall(require, "which-key")
			if wk_ok then
				wk.add({
					{ "<leader>f", group = " Find", icon = "" },
					{ "<leader>fg", group = " Git", icon = "" },
				})
			end
		end,
	},

	-- ============ UI Select ============
	{
		"nvim-telescope/telescope-ui-select.nvim",
		config = function()
			require("telescope").setup({
				extensions = {
					["ui-select"] = {
						require("telescope.themes").get_dropdown({
							previewer = false,
							initial_mode = "normal",
							sorting_strategy = "ascending",
							layout_strategy = "cursor",
							layout_config = {
								width = 0.5,
								height = 0.4,
							},
						}),
					},
				},
			})
			require("telescope").load_extension("ui-select")
		end,
	},
}
