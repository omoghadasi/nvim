return {
	"nvim-neo-tree/neo-tree.nvim",
	branch = "v3.x",
	dependencies = {
		"nvim-lua/plenary.nvim",
		"nvim-tree/nvim-web-devicons",
		"MunifTanjim/nui.nvim",
	},
	cmd = "Neotree",
	keys = {
		{
			"<C-e>",":Neotree toggle float<cr>",
			desc = "Toggle Neo-tree (Float)",
		},
	},
	config = function()
		vim.fn.sign_define("DiagnosticSignError", { text = " ", texthl = "DiagnosticSignError" })
		vim.fn.sign_define("DiagnosticSignWarn", { text = " ", texthl = "DiagnosticSignWarn" })
		vim.fn.sign_define("DiagnosticSignInfo", { text = " ", texthl = "DiagnosticSignInfo" })
		vim.fn.sign_define("DiagnosticSignHint", { text = "󰌵", texthl = "DiagnosticSignHint" })

		require("neo-tree").setup({
			popup_border_style = "rounded",
			enable_git_status = true,
			enable_diagnostics = true,
			enable_normal_mode_for_inputs = false,
			open_files_do_not_replace_types = { "terminal", "trouble", "qf" },
			sort_case_insensitive = false,

			-- ============ Default Component Configs ============
			default_component_configs = {
				container = {
					enable_character_fade = true,
				},
				indent = {
					indent_size = 2,
					padding = 1,
					with_markers = true,
					indent_marker = "│",
					last_indent_marker = "└",
					highlight = "NeoTreeIndentMarker",
					with_expanders = true,
					expander_collapsed = "",
					expander_expanded = "",
					expander_highlight = "NeoTreeExpander",
				},
				icon = {
					default = "󰈙",
					highlight = "NeoTreeFileIcon",
				},
				modified = {
					symbol = "●",
					highlight = "NeoTreeModified",
				},
				name = {
					trailing_slash = false,
					use_git_status_colors = true,
					highlight = "NeoTreeFileName",
				},
				git_status = {
					symbols = {
						-- Change type
						added = "+", -- or "✚", but this is redundant info if you use git_status_colors on the name
						modified = "", -- or "", but this is redundant info if you use git_status_colors on the name
						deleted = "✖", -- this can only be used in the git_status source
						renamed = "󰁕", -- this can only be used in the git_status source
						-- Status type
						untracked = "",
						ignored = "",
						unstaged = "󰄱",
						staged = "",
						conflict = "",
					},
				},
				file_size = {
					enabled = true,
					required_width = 64,
				},
				type = {
					enabled = true,
					required_width = 122,
				},
				last_modified = {
					enabled = true,
					required_width = 88,
				},
				created = {
					enabled = true,
					required_width = 110,
				},
				symlink_target = {
					enabled = false,
				},
			},

			-- ============ Commands (اختیاری) ============
			commands = {
				-- Custom command برای کپی path
				copy_selector = function(state)
					local node = state.tree:get_node()
					local filepath = node:get_id()
					local filename = node.name
					local modify = vim.fn.fnamemodify

					local results = {
						filepath,
						modify(filepath, ":."),
						modify(filepath, ":~"),
						filename,
						modify(filename, ":r"),
						modify(filename, ":e"),
					}

					vim.ui.select({
						"1. Absolute path: " .. results[1],
						"2. Path relative to CWD: " .. results[2],
						"3. Path relative to HOME: " .. results[3],
						"4. Filename: " .. results[4],
						"5. Filename without extension: " .. results[5],
						"6. Extension of the filename: " .. results[6],
					}, { prompt = "Choose to copy to clipboard:" }, function(choice)
						if choice then
							local i = tonumber(choice:sub(1, 1))
							if i then
								local result = results[i]
								vim.fn.setreg("+", result)
								vim.notify("Copied: " .. result)
							end
						end
					end)
				end,
			},

			-- ============ Window (Float Mode) ============
			window = {
				position = "float",
				width = 80, -- عرض float window
				popup = {
					size = {
						height = "80%",
						width = "80%",
					},
					position = "50%",
				},
				mapping_options = {
					noremap = true,
					nowait = true,
				},
			},

			-- ============ Filesystem ============
			filesystem = {
				filtered_items = {
					visible = false,
					hide_dotfiles = false,
					hide_gitignored = false,
					hide_hidden = true,
					hide_by_name = {
						".DS_Store",
						"thumbs.db",
						"node_modules",
					},
					hide_by_pattern = {
						--"*.meta",
						--"*/src/*/tsconfig.json",
					},
					always_show = {
						".gitignore",
						".env",
					},
					always_show_by_pattern = {
						".env*",
					},
					never_show = {
						".DS_Store",
						"thumbs.db",
					},
					never_show_by_pattern = {
						".null-ls_*",
					},
				},
				follow_current_file = {
					enabled = true,
					leave_dirs_open = false,
				},
				group_empty_dirs = false,
				hijack_netrw_behavior = "open_default",
				use_libuv_file_watcher = true, -- auto-refresh
			},

			-- ============ Buffers ============
			buffers = {
				follow_current_file = {
					enabled = true,
					leave_dirs_open = false,
				},
				group_empty_dirs = true,
				show_unloaded = true,
				window = {
					mappings = {
						["bd"] = "buffer_delete",
						["<bs>"] = "navigate_up",
						["."] = "set_root",
						["o"] = { "show_help", nowait = false, config = { title = "Order by", prefix_key = "o" } },
						["oc"] = { "order_by_created", nowait = false },
						["od"] = { "order_by_diagnostics", nowait = false },
						["om"] = { "order_by_modified", nowait = false },
						["on"] = { "order_by_name", nowait = false },
						["os"] = { "order_by_size", nowait = false },
						["ot"] = { "order_by_type", nowait = false },
					},
				},
			},

			-- ============ Git Status ============
			git_status = {
				window = {
					position = "float",
					mappings = {
						["A"] = "git_add_all",
						["gu"] = "git_unstage_file",
						["ga"] = "git_add_file",
						["gr"] = "git_revert_file",
						["gc"] = "git_commit",
						["gp"] = "git_push",
						["gg"] = "git_commit_and_push",
						["o"] = { "show_help", nowait = false, config = { title = "Order by", prefix_key = "o" } },
						["oc"] = { "order_by_created", nowait = false },
						["od"] = { "order_by_diagnostics", nowait = false },
						["om"] = { "order_by_modified", nowait = false },
						["on"] = { "order_by_name", nowait = false },
						["os"] = { "order_by_size", nowait = false },
						["ot"] = { "order_by_type", nowait = false },
					},
				},
			},
      source_selector = {
        winbar = true,
        statusline = true,
      },
		})

		-- ============ Custom Highlights ============
		vim.api.nvim_set_hl(0, "NeoTreeFloatBorder", { fg = "#7aa2f7", bg = "none" })
		vim.api.nvim_set_hl(0, "NeoTreeFloatTitle", { fg = "#7aa2f7", bg = "none", bold = true })

		-- Git status colors
		vim.api.nvim_set_hl(0, "NeoTreeGitAdded", { fg = "#9ece6a" })
		vim.api.nvim_set_hl(0, "NeoTreeGitModified", { fg = "#e0af68" })
		vim.api.nvim_set_hl(0, "NeoTreeGitDeleted", { fg = "#f7768e" })
		vim.api.nvim_set_hl(0, "NeoTreeGitConflict", { fg = "#bb9af7" })
		vim.api.nvim_set_hl(0, "NeoTreeGitUntracked", { fg = "#73daca" })
		vim.api.nvim_set_hl(0, "NeoTreeGitIgnored", { fg = "#545c7e" })
		vim.api.nvim_set_hl(0, "NeoTreeGitUnstaged", { fg = "#db4b4b" })
		vim.api.nvim_set_hl(0, "NeoTreeGitStaged", { fg = "#9ece6a" })

		-- File/Folder icons
		vim.api.nvim_set_hl(0, "NeoTreeDirectoryIcon", { fg = "#7aa2f7" })
		vim.api.nvim_set_hl(0, "NeoTreeDirectoryName", { fg = "#7aa2f7" })
		vim.api.nvim_set_hl(0, "NeoTreeFileIcon", { fg = "#c0caf5" })
		vim.api.nvim_set_hl(0, "NeoTreeFileName", { fg = "#c0caf5" })
		vim.api.nvim_set_hl(0, "NeoTreeModified", { fg = "#e0af68" })
		vim.api.nvim_set_hl(0, "NeoTreeIndentMarker", { fg = "#3b4261" })
		vim.api.nvim_set_hl(0, "NeoTreeExpander", { fg = "#7aa2f7" })

		-- ============ Integration با which-key ============
		local wk_ok, wk = pcall(require, "which-key")
		if wk_ok then
			wk.add({
				{ "<C-e>", desc = "󰙅 Toggle Explorer (Float)" },
			})
		end
	end,
}
