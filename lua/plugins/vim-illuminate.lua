return {
	"RRethy/vim-illuminate",
	event = { "BufReadPost", "BufNewFile" },
	opts = {
		-- ============ Providers ============
		providers = {
			"lsp", -- از LSP استفاده کنه
			"treesitter", -- از treesitter استفاده کنه
			"regex", -- fallback به regex
		},

		-- ============ Delay ============
		delay = 100, -- تاخیر قبل از highlight (میلی‌ثانیه)
		large_file_cutoff = 2000, -- خطوط بیشتر از این → غیرفعال
		large_file_overrides = nil,

		-- ============ Filetypes ============
		filetypes_denylist = {
			"dirbuf",
			"dirvish",
			"fugitive",
			"alpha",
			"NvimTree",
			"neo-tree",
			"dashboard",
			"TelescopePrompt",
			"TelescopeResults",
			"DressingInput",
			"toggleterm",
			"DiffviewFiles",
			"oil",
			"spectre_panel",
			"undotree",
			"Outline",
			"qf",
			"help",
		},

		-- ============ Modes ============
		modes_denylist = {},
		modes_allowlist = {},

		-- ============ Under Cursor ============
		under_cursor = true, -- highlight کلمه زیر cursor

		-- ============ Min Count to Highlight ============
		min_count_to_highlight = 1, -- حداقل تعداد برای highlight

		-- ============ Case Insensitive ============
		case_insensitive_regex = false,
	},
	config = function(_, opts)
		require("illuminate").configure(opts)

		-- ============ Custom Highlights ============
		local function set_illuminate_hl()
			vim.api.nvim_set_hl(0, "IlluminatedWordText", {
				bg = "#3b4261",
				underline = false,
			})
			vim.api.nvim_set_hl(0, "IlluminatedWordRead", {
				bg = "#3b4261",
				underline = false,
			})
			vim.api.nvim_set_hl(0, "IlluminatedWordWrite", {
				bg = "#3d59a1",
				underline = false,
			})
		end

		set_illuminate_hl()

		-- Re-apply بعد از تغییر colorscheme
		vim.api.nvim_create_autocmd("ColorScheme", {
			callback = set_illuminate_hl,
		})

		-- ============ Keymaps ============
		local function map(key, dir, buffer)
			vim.keymap.set("n", key, function()
				require("illuminate")["goto_" .. dir .. "_reference"](false)
			end, {
				desc = dir:sub(1, 1):upper() .. dir:sub(2) .. " Reference",
				buffer = buffer,
			})
		end

		-- Navigation بین references
		map("]]", "next")
		map("[[", "prev")

		-- Alternative navigation
		vim.keymap.set("n", "<a-n>", function()
			require("illuminate").goto_next_reference(false)
		end, { desc = "Next Reference" })

		vim.keymap.set("n", "<a-p>", function()
			require("illuminate").goto_prev_reference(false)
		end, { desc = "Prev Reference" })

		-- Toggle illuminate
		vim.keymap.set("n", "<leader>ti", function()
			require("illuminate").toggle()
		end, { desc = "Toggle Illuminate" })

		-- Pause/Resume
		vim.keymap.set("n", "<leader>tI", function()
			require("illuminate").pause()
			vim.notify("Illuminate paused", vim.log.levels.INFO)
		end, { desc = "Pause Illuminate" })

		vim.keymap.set("n", "<leader>tr", function()
			require("illuminate").resume()
			vim.notify("Illuminate resumed", vim.log.levels.INFO)
		end, { desc = "Resume Illuminate" })

		-- ============ Auto Commands ============
		-- Pause در insert mode (اختیاری)
		vim.api.nvim_create_autocmd("InsertEnter", {
			callback = function()
				require("illuminate").pause_buf()
			end,
		})

		vim.api.nvim_create_autocmd("InsertLeave", {
			callback = function()
				require("illuminate").resume_buf()
			end,
		})

		-- غیرفعال در telescope
		vim.api.nvim_create_autocmd("FileType", {
			pattern = { "TelescopePrompt", "TelescopeResults" },
			callback = function()
				require("illuminate").pause_buf()
			end,
		})

		-- ============ Integration با LSP ============
		-- خودکار با LSP attach میشه
		vim.api.nvim_create_autocmd("LspAttach", {
			callback = function(args)
				local buffer = args.buf
				local client = vim.lsp.get_client_by_id(args.data.client_id)

				-- فقط اگه LSP document highlight support داره
				if client and client.server_capabilities.documentHighlightProvider then
					-- Illuminate خودکار فعال میشه
				end
			end,
		})

		-- ============ Status Line Integration (اختیاری) ============
		-- نمایش تعداد references در statusline
		_G.illuminate_status = function()
			local status = require("illuminate.engine").status_string()
			if status and status ~= "" then
				return "  " .. status
			end
			return ""
		end

		-- ============ Integration با which-key ============
		local wk_ok, wk = pcall(require, "which-key")
		if wk_ok then
			wk.add({
				{ "]]", desc = "Next Reference" },
				{ "[[", desc = "Prev Reference" },
				{ "<a-n>", desc = "Next Reference" },
				{ "<a-p>", desc = "Prev Reference" },
			})
		end
	end,
}
