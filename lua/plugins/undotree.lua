return {
	"mbbill/undotree",
	config = function()
		vim.keymap.set("n", "<leader><F6>", vim.cmd.UndotreeToggle)
	end,
}
