return {
	"folke/which-key.nvim",
	event = "VeryLazy",
	init = function()
		vim.o.timeout = true
		vim.o.timeoutlen = 300
	end,
	opts = {
		preset = "modern", -- یا "classic" یا "helix"
		delay = 200, -- زمان کمتر برای نمایش سریع‌تر
		plugins = {
			marks = true,
			registers = true,
			spelling = {
				enabled = true,
				suggestions = 20,
			},
			presets = {
				operators = true, -- y, d, c, ...
				motions = true, -- w, b, e, ...
				text_objects = true, -- iw, aw, ...
				windows = true, -- <C-w>
				nav = true, -- [], )(, ...
				z = true, -- z=, zf, ...
				g = true, -- gg, gd, ...
			},
		},

		-- آیکون‌ها و ظاهر
		icons = {
			breadcrumb = "»",
			separator = "➜",
			group = "+",
			ellipsis = "…",
			mappings = true, -- نمایش آیکون برای keymap ها
			keys = {
				Up = "󰁝 ",
				Down = "󰁅 ",
				Left = "󰁍 ",
				Right = "󰁔 ",
				C = "󰘴 ",
				M = "󰘵 ",
				S = "󰘶 ",
				CR = "󰌑 ",
				Esc = "󱊷 ",
				ScrollWheelDown = "󱕐 ",
				ScrollWheelUp = "󱕑 ",
				NL = "󰌑 ",
				BS = "⌫",
				Space = "󱁐 ",
				Tab = "󰌒 ",
			},
		},

		-- تنظیمات نمایش
		win = {
			border = "rounded", -- یا "single", "double", "shadow"
			padding = { 1, 2 }, -- [top/bottom, right/left]
			title = true,
			title_pos = "center",
			zindex = 1000,
		},

		layout = {
			height = { min = 4, max = 25 },
			width = { min = 20, max = 50 },
			spacing = 3,
			align = "left",
		},

		-- گروه‌بندی کلیدها
		spec = {
			-- Leader mappings
			{ "<leader>a", group = "🤖 AI", icon = "󰧑" },
			{ "<leader>b", group = "󰓩 Buffers", icon = "󰓩" },
			{ "<leader>c", group = " Code", icon = "" }, -- LSP actions
			{ "<leader>d", group = "󰃤 Debug", icon = "󰃤" }, -- اگر DAP داری
			{ "<leader>f", group = " Find", icon = "" },
			{ "<leader>ff", group = "📁 Find File" }, -- اضافه شد
			{ "<leader>fh", group = "󰋖 Find Help" }, -- اضافه شد
			{ "<leader>g", group = "󰊢 Git", icon = "󰊢" }, -- اگر Git plugins داری
			{ "<leader>k", group = " Keymaps", icon = "" },
			{ "<leader>l", group = "󰘦 LSP", icon = "󰘦" },
			{ "<leader>s", group = " Search", icon = "" },
			{ "<leader>t", group = " Toggle", icon = "" },
			{ "<leader>v", group = " Venv", icon = "" },
			{ "<leader>x", group = "󰱼 Trouble", icon = "󰱼" },
			{ "<leader>w", group = "󰖯 Window", icon = "󰖯" },
			{ "<leader><leader>", group = "󰉖 Go to", icon = "󰉖" },

			-- برای دسترسی سریع به which-key خودش
			{ "<leader>?", "<cmd>WhichKey<cr>", desc = "Show All Keymaps", icon = "󰋗" },
			{ "<leader>k?", "<cmd>WhichKey<cr>", desc = "All Keymaps" },

			-- مثال‌هایی از mappingهای معمول
			{ "<leader>e", group = " Explorer", icon = "" },
			{ "<leader>q", group = " Quit/Session", icon = "" },

			-- گروه‌های با [] یا g
			{ "[", group = " Previous" },
			{ "]", group = " Next" },
			{ "g", group = " Goto" },
			{ "z", group = "󰇘 Fold" },
			{ "s", group = "󰒕 Surround" }, -- اگر surround plugin داری

			-- Text objects
			{ "i", group = "󰀫 Inside" },
			{ "a", group = "󰀬 Around" },
		},

		-- ترتیب نمایش
		sort = { "local", "order", "group", "alphanum", "mod" },

		-- تنظیمات اضافی
		triggers = {
			{ "<auto>", mode = "nxsot" },
		},
	},

	-- اضافه کردن keymapهای اضافی
	keys = {
		{
			"<leader>?",
			function()
				require("which-key").show({ global = false })
			end,
			desc = "Buffer Keymaps (which-key)",
		},
		{
			"<c-w><space>",
			function()
				require("which-key").show({ keys = "<c-w>", loop = true })
			end,
			desc = "Window Hydra Mode (which-key)",
		},
	},
}
