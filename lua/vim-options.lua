vim.cmd("set clipboard=unnamedplus")
vim.cmd("set number")
vim.cmd("set tabstop=4")
vim.cmd("set shiftwidth=4")
vim.cmd("set expandtab")
vim.cmd("set arabicshape!")
vim.g.mapleader = " "
vim.keymap.set("n", "<A-j>", ":m +1<CR>", {})
vim.keymap.set("n", "<A-k>", ":m -2<CR>", {})
vim.keymap.set("i", "kj", "<Esc>", {})
vim.keymap.set("i", '"', '""<left>', { noremap = true })
vim.keymap.set("i", "'", "''<left>", { noremap = true })
vim.keymap.set("i", "(", "()<left>", { noremap = true })
vim.keymap.set("i", "[", "[]<left>", { noremap = true })
vim.keymap.set("i", "{", "{}<left>", { noremap = true })
