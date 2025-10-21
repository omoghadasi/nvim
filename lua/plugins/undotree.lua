return {
	"mbbill/undotree",
	cmd = { "UndotreeToggle", "UndotreeShow", "UndotreeHide" },
	keys = {
		{ "<leader>u", "<cmd>UndotreeToggle<cr>", desc = "Toggle Undo Tree" },
	},
	config = function()
		-- ============ تنظیمات Undotree ============
		vim.g.undotree_WindowLayout = 2 -- Layout: tree سمت چپ، diff پایین
		vim.g.undotree_SplitWidth = 35 -- عرض پنجره
		vim.g.undotree_DiffpanelHeight = 10 -- ارتفاع diff panel
		vim.g.undotree_DiffAutoOpen = 1 -- باز کردن خودکار diff
		vim.g.undotree_SetFocusWhenToggle = 1 -- focus به undotree وقتی باز میشه
		vim.g.undotree_ShortIndicators = 1 -- indicators کوتاه (s, m, h به جای saved, modified, hours)
		vim.g.undotree_TreeNodeShape = "●" -- شکل node: ● یا * یا •
		vim.g.undotree_TreeVertShape = "│" -- خط عمودی
		vim.g.undotree_TreeSplitShape = "╱" -- خط شاخه
		vim.g.undotree_TreeReturnShape = "╲" -- خط برگشت
		vim.g.undotree_DiffCommand = "diff" -- دستور diff

		-- ============ Highlight Time ============
		vim.g.undotree_HighlightChangedText = 1 -- highlight تغییرات
		vim.g.undotree_HighlightChangedWithSign = 1 -- نمایش sign
		vim.g.undotree_HighlightSyntaxAdd = "DiffAdd" -- رنگ اضافه شده
		vim.g.undotree_HighlightSyntaxChange = "DiffChange" -- رنگ تغییر یافته
		vim.g.undotree_HighlightSyntaxDel = "DiffDelete" -- رنگ حذف شده

		-- ============ Persistent Undo ============
		-- فعال کردن persistent undo (ذخیره بین sessionها)
		vim.opt.undofile = true
		vim.opt.undodir = vim.fn.stdpath("data") .. "/undo"
		vim.opt.undolevels = 10000 -- تعداد زیاد undo
		vim.opt.undoreload = 10000 -- حداکثر خطوط reload

		-- ساخت دایرکتوری undo اگه وجود نداره
		local undo_dir = vim.fn.stdpath("data") .. "/undo"
		if vim.fn.isdirectory(undo_dir) == 0 then
			vim.fn.mkdir(undo_dir, "p")
		end

		-- ============ Custom Highlights ============
		vim.api.nvim_create_autocmd("FileType", {
			pattern = "undotree",
			callback = function()
				-- Undotree window
				vim.api.nvim_set_hl(0, "UndotreeNode", { fg = "#7aa2f7" })
				vim.api.nvim_set_hl(0, "UndotreeNodeCurrent", { fg = "#9ece6a", bold = true })
				vim.api.nvim_set_hl(0, "UndotreeSeq", { fg = "#565f89" })
				vim.api.nvim_set_hl(0, "UndotreeNext", { fg = "#7dcfff" })
				vim.api.nvim_set_hl(0, "UndotreeTimeStamp", { fg = "#bb9af7" })
				vim.api.nvim_set_hl(0, "UndotreeSavedSmall", { fg = "#f7768e" })
				vim.api.nvim_set_hl(0, "UndotreeSavedBig", { fg = "#f7768e", bold = true })

				-- Keymaps در undotree window
				local opts = { buffer = true, silent = true }
				vim.keymap.set("n", "q", "<cmd>UndotreeHide<cr>", opts)
				vim.keymap.set("n", "<Esc>", "<cmd>UndotreeHide<cr>", opts)
				vim.keymap.set("n", "J", "5j", opts) -- پرش سریع‌تر
				vim.keymap.set("n", "K", "5k", opts)
			end,
		})

		-- ============ Auto Commands ============
		-- نمایش message وقتی undotree باز میشه
		vim.api.nvim_create_autocmd("FileType", {
			pattern = "undotree",
			callback = function()
				vim.notify("Undotree opened. Press ? for help", vim.log.levels.INFO)
			end,
			once = false,
		})

		-- ============ Keymaps اضافی ============
		-- Keymaps برای undo/redo سریع‌تر
		vim.keymap.set("n", "U", "<C-r>", { desc = "Redo" }) -- U برای redo
		vim.keymap.set("n", "<leader>ur", "<cmd>earlier 1f<cr>", { desc = "Undo to last file write" })
		vim.keymap.set("n", "<leader>uf", "<cmd>later 1f<cr>", { desc = "Redo to next file write" })
		vim.keymap.set("n", "<leader>ut", function()
			vim.ui.input({ prompt = "Go to time (e.g., 10m, 1h, 2d): " }, function(input)
				if input then
					vim.cmd("earlier " .. input)
				end
			end)
		end, { desc = "Undo to specific time" })

		-- ============ Integration با which-key ============
		local wk_ok, wk = pcall(require, "which-key")
		if wk_ok then
			wk.add({
				{ "<leader>u", group = " Undo", icon = "" },
				{ "u", desc = "Undo" },
				{ "U", desc = "Redo" },
				{ "<C-r>", desc = "Redo" },
			})
		end

		-- ============ Status Line Integration (اختیاری) ============
		-- نمایش تعداد undos در statusline
		vim.api.nvim_create_autocmd({ "TextChanged", "TextChangedI" }, {
			callback = function()
				vim.b.undo_count = vim.fn.undotree().seq_cur
			end,
		})
	end,
}
