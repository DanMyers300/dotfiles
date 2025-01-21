vim.g.mapleader = ' '
vim.g.maplocalleader = ' '

vim.opt.filetype = "on"
vim.opt.spell = false
vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.syntax = "on"
vim.opt.wrap = false
vim.opt.tabstop = 2      -- Number of spaces a tab counts for
vim.opt.shiftwidth = 2   -- Number of spaces to use for autoindent
vim.opt.expandtab = true -- Convert tabs to spaces
vim.opt.smarttab = true  -- Use shiftwidth for inserting tabs
vim.opt.mouse = "a"
vim.opt.backup = false
vim.opt.incsearch = true
vim.opt.hlsearch = true
vim.opt.ignorecase = true
vim.opt.showmode = true
vim.opt.showcmd = true
vim.opt.history = 1000
vim.opt.undodir = vim.fn.expand("~/.nvim/backup")
vim.opt.undofile = true
vim.opt.undoreload = 10000

vim.opt.listchars = {
  trail = '.',
  tab = '→·',
  lead = '.',
  leadmultispace = '.',
  nbsp = '␣',
  extends = '›',
  precedes = '‹',
}
vim.opt.list = true

vim.o.statuscolumn = "%=%s %l %r |"

-- mini-term
vim.keymap.set("n", "<space>st", function()
  vim.cmd.vnew()
  vim.cmd.term()
  vim.cmd.wincmd("J")
  vim.api.nvim_win_set_height(0,5)
end)

vim.api.nvim_set_keymap('n', '<leader>o', ':Explore<CR>', { noremap = true, silent = true })
