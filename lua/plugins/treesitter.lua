return {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    config = function()
        local configs = require("nvim-treesitter.configs")

        configs.setup({
            auto_install = true,
            sync_install = true,
            highlight = { enable = true },
            indent = { enable = true },
            vim.cmd("set foldmethod=expr"),
            vim.cmd("set foldexpr=nvim_treesitter#foldexpr()"),
            vim.cmd("set nofoldenable"),
        })
    end,
}
