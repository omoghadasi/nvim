return {
    "phaazon/hop.nvim",
    config = function()
        require("hop").setup({ keys = "etovxqpdygfblzhckisuran" })
        vim.keymap.set(
            "n",
            "<Leader><Leader>w",
            "<Cmd>HopWord<CR>",
            { desc = "Go to word in file", noremap = true, silent = true }
        )
        vim.keymap.set(
            "n",
            "<Leader><Leader>l",
            "<Cmd>HopLine<CR>",
            { desc = "Go to line in file", noremap = true, silent = true }
        )
        vim.keymap.set(
            "n",
            "<Leader><Leader>f",
            "<Cmd>HopChar1<CR>",
            { desc = "Go to Char in file", noremap = true, silent = true }
        )
        vim.keymap.set(
            "n",
            "<Leader><Leader>p",
            "<Cmd>HopPattern<CR>",
            { desc = "Go to Pattern in file", noremap = true, silent = true }
        )
    end,
}
