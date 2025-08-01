return {
  "nvim-lualine/lualine.nvim",
  dependencies = { "nvim-tree/nvim-web-devicons" },
  config = function()
    require("lualine").setup({
      options = {
        theme = "dracula",
        section_separators = { left = "", right = "" },
      },
      sections = {
        lualine_c = {
          { require("NeoComposer.ui").status_recording },
        },
      },
    })
  end,
}
