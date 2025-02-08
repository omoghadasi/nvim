vim.cmd("set clipboard=unnamedplus")
vim.cmd("set number")
vim.cmd("set tabstop=4")
vim.cmd("set shiftwidth=4")
vim.cmd("set expandtab")
vim.cmd("set arabicshape!")
vim.cmd("set encoding=utf-8")
vim.cmd("set fileencoding=utf-8")
vim.g.mapleader = " "
vim.keymap.set("n", "<A-j>", ":m +1<CR>", {})
vim.keymap.set("n", "<A-k>", ":m -2<CR>", {})
vim.keymap.set("i", "kj", "<Esc>", {})
vim.api.nvim_create_autocmd("VimEnter", {
  command = "Neotree focus",
})
