return {
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
}
