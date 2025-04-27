vim.cmd("set clipboard=unnamedplus")
vim.cmd("set number")
vim.cmd("set tabstop=2")
vim.cmd("set shiftwidth=2")
vim.cmd("set expandtab")
vim.cmd("set arabicshape!")
vim.cmd("set encoding=utf-8")
vim.cmd("set fileencoding=utf-8")
vim.g.mapleader = " "
vim.keymap.set("n", "<A-j>", ":m +1<CR>", { noremap = true, silent = true })
vim.keymap.set("n", "<A-k>", ":m -2<CR>", { noremap = true, silent = true })
vim.keymap.set("v", "<A-j>", ":m '>+1<CR>gv=gv", { noremap = true, silent = true })
vim.keymap.set("v", "<A-k>", ":m '<-2<CR>gv=gv", { noremap = true, silent = true })
vim.keymap.set("i", "kj", "<Esc>", {})
vim.diagnostic.config({
  virtual_text = {
    spacing = 2,
  },
  signs = true,
  underline = true,
  update_in_insert = false,
  severity_sort = true,
})
