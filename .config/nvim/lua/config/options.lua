local opt = vim.opt

-- line number
opt.relativenumber = true
opt.number = true

-- indent
opt.tabstop = 4
opt.shiftwidth = 4
opt.expandtab = true
opt.autoindent = true

-- unwrap, this is indicate many words can display only on one line, not transform to more than one line.
opt.wrap = true

-- cursorline and mouse
opt.cursorline = false
--opt.mouse:append("a")

-- system clipbroad
opt.clipboard:append("unnamedplus")

-- search ignore case
opt.ignorecase = true
opt.smartcase = true

-- terminal gui color
opt.termguicolors = true

-- use for debuge and some plug tips
opt.signcolumn = "no"

-- cursor
opt.guicursor="n-v-c-i:block"
