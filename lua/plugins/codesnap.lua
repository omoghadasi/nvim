return {
	"mistricky/codesnap.nvim",
	build = "make",
	keys = {
		{ "<leader>cc", "<cmd>CodeSnap<cr>", mode = "x", desc = "Save selected code snapshot into clipboard" },
		{ "<leader>cp", "<cmd>CodeSnapSave<cr>", mode = "x", desc = "Save selected code snapshot in ~/Pictures" },
	},
	opts = {
		save_path = "~/Pictures",
		has_breadcrumbs = true,
		bg_theme = "grape",
    has_line_numbers = true,
    watermark = "omid moghadasi"
	},
}
