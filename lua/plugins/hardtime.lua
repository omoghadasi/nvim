return {
	"m4xshen/hardtime.nvim",
	event = "VeryLazy",
	dependencies = { "MunifTanjim/nui.nvim", "nvim-lua/plenary.nvim" },
	opts = {
		-- ============ حداکثر تکرار مجاز ============
		max_count = 5, -- بعد از 4 بار جلوگیری می‌کنه

		-- ============ کلیدهای غیرفعال ============
		disabled_keys = {
			["<Up>"] = {},
			["<Down>"] = {},
			["<Left>"] = {},
			["<Right>"] = {},
		},

		-- ============ کلیدهای محدود شده ============
		restricted_keys = {
			-- حرکات افقی
			["h"] = { "n", "x" },
			["j"] = { "n", "x" },
			["k"] = { "n", "x" },
			["l"] = { "n", "x" },
			["-"] = { "n", "x" },
			["+"] = { "n", "x" },
			["gj"] = { "n", "x" },
			["gk"] = { "n", "x" },
			["<CR>"] = { "n", "x" },
			["<C-M>"] = { "n", "x" },
			["<C-N>"] = { "n", "x" },
			["<C-P>"] = { "n", "x" },
		},

		-- ============ کلیدهای استثنا (غیرفعال نمی‌شن) ============
		disabled_filetypes = {
			"qf", -- quickfix
			"netrw",
			"NvimTree",
			"neo-tree",
			"lazy",
			"mason",
			"oil",
			"TelescopePrompt",
			"help",
			"checkhealth",
			"lspinfo",
			"man",
			"",
		},

		-- ============ Hint ============
		hint = true, -- نمایش پیغام راهنما
		max_time = 1000, -- زمان مجاز بین کلیدها (میلی‌ثانیه)

		-- ============ Allow different key ============
		allow_different_key = true, -- اگه کلید متفاوت بزنی، ریست میشه

		-- ============ Enabled ============
		enabled = true, -- فعال بودن از اول (می‌تونی false کنی)

		-- ============ Resetting keys ============
		resetting_keys = {
			["0"] = { "n", "x" },
			["1"] = { "n", "x" },
			["2"] = { "n", "x" },
			["3"] = { "n", "x" },
			["4"] = { "n", "x" },
			["5"] = { "n", "x" },
			["6"] = { "n", "x" },
			["7"] = { "n", "x" },
			["8"] = { "n", "x" },
			["9"] = { "n", "x" },
		},

		-- ============ Notification ============
		notification = true, -- نمایش notification
		passive = true, -- حالت passive: فقط warn میده، جلوگیری نمی‌کنه
	},

	config = function(_, opts)
		require("hardtime").setup(opts)

		-- ============ Keymaps ============
		vim.keymap.set("n", "<leader>th", "<cmd>Hardtime toggle<cr>", { desc = "Toggle Hardtime" })
		vim.keymap.set("n", "<leader>tr", "<cmd>Hardtime report<cr>", { desc = "Hardtime Report" })
		-- ============ Autocmd: غیرفعال در فایل‌های خاص ============
		vim.api.nvim_create_autocmd("FileType", {
			pattern = { "oil", "DiffviewFiles", "fugitive" },
			callback = function()
				vim.cmd("Hardtime disable")
			end,
		})

		-- فعال کردن دوباره وقتی از اون فایل‌ها خارج میشی
		vim.api.nvim_create_autocmd("BufLeave", {
			pattern = { "oil://*", "DiffviewFiles", "fugitive://*" },
			callback = function()
				vim.cmd("Hardtime enable")
			end,
		})
	end,
}
