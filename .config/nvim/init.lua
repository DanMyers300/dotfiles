vim.g.mapleader = ' '
vim.g.maplocalleader = ' '

vim.opt.filetype = "on"
vim.opt.spell = false
vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.syntax = "on"
vim.opt.wrap = false
vim.opt.tabstop = 2
vim.opt.shiftwidth = 2
vim.opt.expandtab = true
vim.opt.smarttab = true
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
--vim.keymap.set("n", "<space>st", function()
--  vim.cmd.vnew()
--  vim.cmd.term()
--  vim.cmd.wincmd("J")
--  vim.api.nvim_win_set_height(0,5)
--end)

vim.api.nvim_set_keymap('n', '<leader>o', ':Explore<CR>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<leader>h', ':bp<CR>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<leader>l', ':bn<CR>', { noremap = true, silent = true })

-- Set up ts_ls (TypeScript language server)
local lspconfig = require('lspconfig')
lspconfig.ts_ls.setup({})

-- Attach keybindings when the LSP connects to a buffer
vim.api.nvim_create_autocmd('LspAttach', {
  callback = function(args)
    local client = vim.lsp.get_client_by_id(args.data.client_id)
    if client.name == 'tsserver' then
      -- Go to definition
      vim.keymap.set('n', 'gd', vim.lsp.buf.definition, { buffer = args.buf, desc = 'Go to definition' })

      -- Hover documentation
      vim.keymap.set('n', 'K', vim.lsp.buf.hover, { buffer = args.buf, desc = 'Hover documentation' })

      -- Rename symbol
      vim.keymap.set('n', '<leader>rn', vim.lsp.buf.rename, { buffer = args.buf, desc = 'Rename symbol' })
    end
  end,
})
