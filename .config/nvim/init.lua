-- Basic vim setup
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


-- Keybinds
vim.api.nvim_set_keymap('n', '<leader>o', ':Explore<CR>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<leader>h', ':bp<CR>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<leader>l', ':bn<CR>', { noremap = true, silent = true })


-- LSP
local lspconfig = require('lspconfig')
lspconfig.ts_ls.setup({})

-- nvim-cmp setup
local cmp = require'cmp'

cmp.setup({
  snippet = {
    expand = function(args)
      require('luasnip').lsp_expand(args.body)
    end,
  },
  mapping = {
    ['<C-b>'] = cmp.mapping(cmp.mapping.scroll_docs(-4), { 'i', 'c' }),
    ['<C-f>'] = cmp.mapping(cmp.mapping.scroll_docs(4), { 'i', 'c' }),
    ['<C-Space>'] = cmp.mapping(cmp.mapping.complete(), { 'i', 'c' }),
    ['<C-y>'] = cmp.config.disable, -- Specify `cmp.config.disable` if you want to remove the default `<C-y>` mapping.
    ['<C-e>'] = cmp.mapping({
      i = cmp.mapping.abort(),
      c = cmp.mapping.close(),
    }),
    ['<CR>'] = cmp.mapping.confirm({ select = true }), -- Accept currently selected item. Set `select` to `false` to only confirm explicitly selected items.
  },
  sources = cmp.config.sources({
    { name = 'nvim_lsp' },
    { name = 'luasnip' },
  }, {
    { name = 'buffer' },
  })
})

-- LSP keybindings
vim.api.nvim_create_autocmd('LspAttach', {
  callback = function(args)
    local client = vim.lsp.get_client_by_id(args.data.client_id)
    vim.keymap.set('n', 'gd', vim.lsp.buf.definition, { buffer = args.buf, desc = 'Go to definition' })
    vim.keymap.set('n', 'K', vim.lsp.buf.hover, { buffer = args.buf, desc = 'Hover documentation' })
    vim.keymap.set('n', '<leader>rn', vim.lsp.buf.rename, { buffer = args.buf, desc = 'Rename symbol' })
  end,
})


