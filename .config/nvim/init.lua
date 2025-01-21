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
  trail = '.',      -- Show trailing spaces as dots
  tab = '→·',       -- Show tabs as an arrow followed by a dot
  nbsp = '␣',       -- Show non-breaking spaces (optional)
  space = '.',      -- Show leading spaces as dots
  extends = '›',    -- Show when a line extends off-screen (optional)
  precedes = '‹',   -- Show when a line precedes off-screen (optional)
}
vim.opt.list = true -- Enable showing invisible characters

vim.o.statuscolumn = "%=%s %l %r |"

-- mini-term
vim.keymap.set("n", "<space>st", function()
  vim.cmd.vnew()
  vim.cmd.term()
  vim.cmd.wincmd("J")
  vim.api.nvim_win_set_height(0,5)
end)

vim.api.nvim_set_keymap('n', '<leader>o', ':Explore<CR>', { noremap = true, silent = true })
