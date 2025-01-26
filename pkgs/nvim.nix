{ pkgs, unstable, ... }: {
  programs.neovim = {
    enable = true;
    package = unstable.neovim-unwrapped;
    viAlias = true;
    vimAlias = true;
    plugins = with pkgs.vimPlugins; [
      vim-sleuth
      nvim-lspconfig
      nvim-cmp
      cmp-nvim-lsp
      cmp-buffer
      cmp-path
      cmp-cmdline
      luasnip
      cmp_luasnip
      (nvim-treesitter.withPlugins (p: [
        p.tree-sitter-java
      ]))
      tokyonight-nvim
    ];
    extraPackages = with pkgs; [
      gcc
      stdenv.cc.cc
    ];
    extraLuaConfig = ''
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
      
      
      vim.api.nvim_set_keymap('n', '<leader>o', ':Explore<CR>', { noremap = true, silent = true })
      vim.api.nvim_set_keymap('n', '<leader>h', ':bp<CR>', { noremap = true, silent = true })
      vim.api.nvim_set_keymap('n', '<leader>l', ':bn<CR>', { noremap = true, silent = true })
      
      
      local lspconfig = require('lspconfig')
      lspconfig.ts_ls.setup({})
      
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
          ['<C-y>'] = cmp.config.disable,
          ['<C-e>'] = cmp.mapping({
            i = cmp.mapping.abort(),
            c = cmp.mapping.close(),
          }),
          ['<CR>'] = cmp.mapping.confirm({ select = true }),
        },
        sources = cmp.config.sources({
          { name = 'nvim_lsp' },
          { name = 'luasnip' },
        }, {
          { name = 'buffer' },
        })
      })
      
      vim.api.nvim_create_autocmd('LspAttach', {
        callback = function(args)
          local client = vim.lsp.get_client_by_id(args.data.client_id)
          vim.keymap.set('n', 'gd', vim.lsp.buf.definition, { buffer = args.buf, desc = 'Go to definition' })
          vim.keymap.set('n', 'K', vim.lsp.buf.hover, { buffer = args.buf, desc = 'Hover documentation' })
          vim.keymap.set('n', '<leader>rn', vim.lsp.buf.rename, { buffer = args.buf, desc = 'Rename symbol' })
        end,
      })
      
      vim.opt.termguicolors = true
      
      vim.cmd('colorscheme tokyonight')

      require'nvim-treesitter.configs'.setup {
        parser_install_dir = "${pkgs.vimPlugins.nvim-treesitter}/parser",
        auto_install = false,
        ensure_installed = {"java"},
        highlight = {
          enable = true,
          additional_vim_regex_highlighting = false,
        },
      }
    '';
  };
}
