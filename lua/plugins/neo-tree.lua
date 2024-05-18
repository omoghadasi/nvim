return {
    "nvim-neo-tree/neo-tree.nvim",
    branch = "v3.x",
    dependencies = {
        "nvim-lua/plenary.nvim",
        "nvim-tree/nvim-web-devicons", -- not strictly required, but recommended
        "MunifTanjim/nui.nvim",
    },
    config = function()
        require("neo-tree").setup({
            close_if_last_window = true, -- Close Neo-tree if it is the last window left in the tab
            enable_git_status = true,
            enable_diagnostics = true,
        })
        vim.keymap.set("n", "<C-E>", ":Neotree filesystem reveal left toggle<CR>")
    end,
}
