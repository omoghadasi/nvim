return {
    "pocco81/auto-save.nvim",
    config = function()
        require("auto-save").setup()
        vim.api.nvim_set_keymap("n", "<leader>ts", ":ASToggle<CR>", { desc = "Toggle Auto Save" })
    end

}
