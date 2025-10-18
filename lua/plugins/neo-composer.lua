return {
	"ecthelionvi/NeoComposer.nvim",
	dependencies = { "kkharji/sqlite.lua" },
	event = "VeryLazy",
	opts = {
		-- ============ تنظیمات اصلی ============
		notify = true, -- نمایش notifications
		delay_timer = 150, -- تاخیر برای status updates (میلی‌ثانیه)
		queue_most_recent = false, -- پخش آخرین macro یا اولین

		-- ============ Keybindings ============
		keymaps = {
			play_macro = "Q", -- پخش macro
			yank_macro = "yq", -- کپی macro
			stop_macro = "cq", -- توقف ضبط
			toggle_record = "q", -- شروع/پایان ضبط
			cycle_next = "<c-n>", -- macro بعدی
			cycle_prev = "<c-p>", -- macro قبلی
			toggle_macro_menu = "<m-q>", -- منوی macroها (Alt+q)
		},

		-- ============ Colors ============
		colors = {
			bg = "#16161e",
			fg = "#ff9e64",
			red = "#ec5f67",
			blue = "#5fb3b3",
			green = "#99c794",
		},
	},

	config = function(_, opts)
		require("NeoComposer").setup(opts)

		-- ============ Keymaps اضافی ============
		local keymap = vim.keymap.set

		-- منوی macroها
		keymap("n", "<leader>qm", function()
			require("NeoComposer.ui").toggle_macro_menu()
		end, { desc = "Toggle Macro Menu" })

		-- ویرایش macro
		keymap("n", "<leader>qe", function()
			require("NeoComposer.ui").edit_macros()
		end, { desc = "Edit Macros" })

		-- پخش macro بعدی
		keymap("n", "<leader>qn", function()
			require("NeoComposer.store").cycle_next()
		end, { desc = "Next Macro" })

		-- پخش macro قبلی
		keymap("n", "<leader>qp", function()
			require("NeoComposer.store").cycle_prev()
		end, { desc = "Previous Macro" })

		-- پخش macro با count
		keymap("n", "<leader>qq", function()
			vim.ui.input({ prompt = "Play macro [register]: " }, function(register)
				if register and register ~= "" then
					vim.cmd("normal! @" .. register)
				end
			end)
		end, { desc = "Play Macro by Register" })

		-- حذف macro
		keymap("n", "<leader>qd", function()
			vim.ui.input({ prompt = "Delete macro [register]: " }, function(register)
				if register and register ~= "" then
					require("NeoComposer.store").clear_macro(register)
					vim.notify("Macro " .. register .. " deleted", vim.log.levels.INFO)
				end
			end)
		end, { desc = "Delete Macro" })

		-- Yank macro به clipboard
		keymap("n", "<leader>qy", function()
			vim.ui.input({ prompt = "Yank macro [register]: " }, function(register)
				if register and register ~= "" then
					local macro = vim.fn.getreg(register)
					vim.fn.setreg("+", macro)
					vim.notify("Macro " .. register .. " yanked to clipboard", vim.log.levels.INFO)
				end
			end)
		end, { desc = "Yank Macro to Clipboard" })

		-- Paste macro از clipboard
		keymap("n", "<leader>qP", function()
			vim.ui.input({ prompt = "Paste macro to [register]: " }, function(register)
				if register and register ~= "" then
					local macro = vim.fn.getreg("+")
					vim.fn.setreg(register, macro)
					vim.notify("Macro pasted to " .. register, vim.log.levels.INFO)
				end
			end)
		end, { desc = "Paste Macro from Clipboard" })

		-- نمایش محتوای macro
		keymap("n", "<leader>qv", function()
			vim.ui.input({ prompt = "View macro [register]: " }, function(register)
				if register and register ~= "" then
					local macro = vim.fn.getreg(register)
					if macro and macro ~= "" then
						vim.notify("Macro " .. register .. ":\n" .. macro, vim.log.levels.INFO)
					else
						vim.notify("Macro " .. register .. " is empty", vim.log.levels.WARN)
					end
				end
			end)
		end, { desc = "View Macro Content" })

		-- لیست تمام macroها
		keymap("n", "<leader>ql", function()
			local macros = {}
			for i = 97, 122 do -- a-z
				local char = string.char(i)
				local macro = vim.fn.getreg(char)
				if macro and macro ~= "" then
					table.insert(macros, string.format("%s: %s", char, macro:sub(1, 50)))
				end
			end
			if #macros > 0 then
				vim.notify("Recorded Macros:\n" .. table.concat(macros, "\n"), vim.log.levels.INFO)
			else
				vim.notify("No macros recorded", vim.log.levels.WARN)
			end
		end, { desc = "List All Macros" })

		-- حذف تمام macroها
		keymap("n", "<leader>qC", function()
			vim.ui.select({ "Yes", "No" }, {
				prompt = "Delete all macros?",
			}, function(choice)
				if choice == "Yes" then
					for i = 97, 122 do
						vim.fn.setreg(string.char(i), "")
					end
					vim.notify("All macros deleted", vim.log.levels.INFO)
				end
			end)
		end, { desc = "Clear All Macros" })

		-- ============ Telescope Integration (اختیاری) ============
		local telescope_ok, telescope = pcall(require, "telescope")
		if telescope_ok then
			telescope.load_extension("macros")

			keymap("n", "<leader>qt", function()
				require("telescope").extensions.macros.macros()
			end, { desc = "Telescope Macros" })
		end

		-- ============ Integration با which-key ============
		local wk_ok, wk = pcall(require, "which-key")
		if wk_ok then
			wk.add({
				{ "<leader>q", group = "󰑋 Macros", icon = "󰑋" },
				{ "q", desc = "Record Macro" },
				{ "Q", desc = "Play Macro" },
				{ "yq", desc = "Yank Macro" },
				{ "cq", desc = "Stop Recording" },
				{ "<c-n>", desc = "Next Macro" },
				{ "<c-p>", desc = "Previous Macro" },
			})
		end

		-- ============ Autocmd: Statusline Integration ============
		vim.api.nvim_create_autocmd("RecordingEnter", {
			callback = function()
				vim.g.macro_recording = true
			end,
		})

		vim.api.nvim_create_autocmd("RecordingLeave", {
			callback = function()
				vim.g.macro_recording = false
			end,
		})

		-- ============ Custom Highlights ============
		vim.api.nvim_set_hl(0, "NeoComposerNormal", { link = "Normal" })
		vim.api.nvim_set_hl(0, "NeoComposerBorder", { link = "FloatBorder" })
	end,
}
