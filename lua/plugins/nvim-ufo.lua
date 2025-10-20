return {
	"kevinhwang91/nvim-ufo",
	dependencies = {
		"kevinhwang91/promise-async",
		{
			"luukvbaal/statuscol.nvim",
			config = function()
				local builtin = require("statuscol.builtin")
				require("statuscol").setup({
					relculnumber = true,
					segments = {
						{ text = { builtin.foldfunc }, click = "v:lua.ScFa" },
						{ text = { "%s" }, click = "v:lua.ScSa" },
						{ text = { builtin.lnumfunc, " " }, click = "v:lua.ScLa" },
					},
				})
			end,
		},
	},
	event = "BufReadPost",
	keys = {
		{
			"zR",
			function()
				require("ufo").openAllFolds()
			end,
			desc = "Open all folds",
		},
		{
			"zM",
			function()
				require("ufo").closeAllFolds()
			end,
			desc = "Close all folds",
		},
		{
			"zr",
			function()
				require("ufo").openFoldsExceptKinds()
			end,
			desc = "Fold less",
		},
		{
			"zm",
			function()
				require("ufo").closeFoldsWith()
			end,
			desc = "Fold more",
		},
		{
			"zp",
			function()
				require("ufo").peekFoldedLinesUnderCursor()
			end,
			desc = "Peek fold",
		},
	},
	opts = {
		-- ============ Provider Priority ============
		provider_selector = function(bufnr, filetype, buftype)
			return { "treesitter", "indent" }
		end,

		-- ============ Open Fold hl timeout ============
		open_fold_hl_timeout = 150,

		-- ============ Close Fold Kinds ============
		close_fold_kinds_for_ft = {
			default = { "imports", "comment" },
			json = { "array" },
			c = { "comment", "region" },
		},

		-- ============ Preview ============
		preview = {
			win_config = {
				border = { "", "─", "", "", "", "─", "", "" },
				winhighlight = "Normal:Folded",
				winblend = 0,
			},
			mappings = {
				scrollU = "<C-u>",
				scrollD = "<C-d>",
				jumpTop = "[",
				jumpBot = "]",
			},
		},

		-- ============ Fold Virt Text Handler ============
		fold_virt_text_handler = function(virtText, lnum, endLnum, width, truncate)
			local newVirtText = {}
			local suffix = ("  %d "):format(endLnum - lnum)
			local sufWidth = vim.fn.strdisplaywidth(suffix)
			local targetWidth = width - sufWidth
			local curWidth = 0

			for _, chunk in ipairs(virtText) do
				local chunkText = chunk[1]
				local chunkWidth = vim.fn.strdisplaywidth(chunkText)
				if targetWidth > curWidth + chunkWidth then
					table.insert(newVirtText, chunk)
				else
					chunkText = truncate(chunkText, targetWidth - curWidth)
					local hlGroup = chunk[2]
					table.insert(newVirtText, { chunkText, hlGroup })
					chunkWidth = vim.fn.strdisplaywidth(chunkText)
					if curWidth + chunkWidth < targetWidth then
						suffix = suffix .. (" "):rep(targetWidth - curWidth - chunkWidth)
					end
					break
				end
				curWidth = curWidth + chunkWidth
			end

			table.insert(newVirtText, { suffix, "MoreMsg" })
			return newVirtText
		end,

		-- ============ Enable Get Fold Virt Text ============
		enable_get_fold_virt_text = false,
	},

	config = function(_, opts)
		-- ============ Folding Settings ============
		vim.o.foldcolumn = "1" -- نمایش fold column
		vim.o.foldlevel = 99 -- همه فولدها باز
		vim.o.foldlevelstart = 99 -- شروع با همه باز
		vim.o.foldenable = true -- فعال کردن folding

		-- ============ Setup UFO ============
		require("ufo").setup(opts)

		-- ============ Custom Highlights ============
		vim.api.nvim_set_hl(0, "Folded", { bg = "#1a1b26", fg = "#565f89", italic = true })
		vim.api.nvim_set_hl(0, "FoldColumn", { bg = "none", fg = "#3b4261" })
		vim.api.nvim_set_hl(0, "UfoFoldedEllipsis", { fg = "#7aa2f7" })

		-- ============ Integration با LSP ============
		-- اگه می‌خوای از LSP folding استفاده کنی:
		local capabilities = vim.lsp.protocol.make_client_capabilities()
		capabilities.textDocument.foldingRange = {
			dynamicRegistration = false,
			lineFoldingOnly = true,
		}

		-- این رو به LSP config اضافه کن:
		-- require("lspconfig").lua_ls.setup({
		--     capabilities = capabilities
		-- })

		-- ============ Keymaps اضافی ============
		vim.keymap.set("n", "K", function()
			local winid = require("ufo").peekFoldedLinesUnderCursor()
			if not winid then
				-- اگه fold نبود، fallback به LSP hover
				vim.lsp.buf.hover()
			end
		end, { desc = "Peek Fold / LSP Hover" })

		-- ============ Auto Commands ============
		-- Save fold state
		vim.api.nvim_create_autocmd({ "BufWinLeave" }, {
			pattern = "*.*",
			callback = function()
				vim.cmd("mkview")
			end,
		})

		-- Load fold state
		vim.api.nvim_create_autocmd({ "BufWinEnter" }, {
			pattern = "*.*",
			callback = function()
				vim.cmd("silent! loadview")
			end,
		})

		-- ============ Integration با which-key ============
		local wk_ok, wk = pcall(require, "which-key")
		if wk_ok then
			wk.add({
				{ "z", group = "󰘖 Fold", icon = "󰘖" },
				{ "zR", desc = "Open all folds" },
				{ "zM", desc = "Close all folds" },
				{ "zr", desc = "Fold less" },
				{ "zm", desc = "Fold more" },
				{ "zp", desc = "Peek fold" },
				{ "za", desc = "Toggle fold" },
				{ "zA", desc = "Toggle all folds recursively" },
				{ "zo", desc = "Open fold" },
				{ "zO", desc = "Open folds recursively" },
				{ "zc", desc = "Close fold" },
				{ "zC", desc = "Close folds recursively" },
			})
		end
	end,
}
