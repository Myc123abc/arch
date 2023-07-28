vim.g.mapleader = " " local keymap = vim.keymap

keymap.set("v", "<C-c>", "\"+yy")

keymap.set("n", "<C-n>h", ":nohl<CR>")

keymap.set("n", "<C-t>", ":NvimTreeToggle<CR>")

keymap.set("n", "<C-l>", ":bnext<CR>")
keymap.set("n", "<C-h>", ":bprevious<CR>")

keymap.set("t", "<C-[>", "<C-\\><C-n>")
