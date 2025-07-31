return {
  "m4xshen/hardtime.nvim",
  lazy = false,
  dependencies = { "MunifTanjim/nui.nvim" },
  opts = {},
  init = function()
    vim.keymap.set({ "n", "v" }, "<leader>th", ":Hardtime toggle<CR>", { desc = "Toggle Hardtime" })
  end,
}
