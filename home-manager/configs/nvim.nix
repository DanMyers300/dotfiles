{ pkgs, unstable, ... }:
{
  stylix.targets.neovim = {
    transparentBackground = {
      main = true;
      signColumn = true;
    };
  };
  programs.neovim = {
    enable = true;
    package = unstable.neovim-unwrapped;
    viAlias = true;
    vimAlias = true;
    plugins = with unstable.vimPlugins; [
      {
        plugin = nvim-lspconfig;
        type = "lua";
        config = ''
          -- Define/override configs for servers
          vim.lsp.config("ts_ls", {})
          vim.lsp.config("pyright", {})

          -- Enable (auto start) them
          vim.lsp.enable("ts_ls")
          vim.lsp.enable("pyright")
        '';
      }
      {
        plugin = mason-nvim;
        type = "lua";
        config = ''
          require("mason").setup()
        '';
      }
      {
        plugin = mason-lspconfig-nvim;
        type = "lua";
        config = ''
          require("mason-lspconfig").setup({
            ensure_installed = {},
          })
        '';
      }
      {
        plugin = pkgs.rust-analyzer;
        type = "lua";
        config = ''
          vim.lsp.config("rust_analyzer", {
            settings = {
              ["rust-analyzer"] = {
                diagnostics = {
                  enable = true,
                },
                checkOnSave = true,
                check = {
                  command = "clippy",
                },
                procMacro = {
                  ignored = {
                    leptos_macro = {
                      -- "component",
                      -- "server",
                    },
                  },
                },
              },
            },
          })

          vim.lsp.enable("rust_analyzer")
        '';
      }
      {
        plugin = nvim-cmp;
        type = "lua";
        config = ''
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
        '';
      }
      {
        plugin = neo-tree-nvim;
        type = "lua";
        config = ''
          require("neo-tree").setup({
            close_if_last_window = true,
            window = {
              width = 30,
            },
            filesystem = {
              follow_current_file = {
                enabled = true,
              },
              hijack_netrw_behavior = "open_current",
            },
          })
        '';
      }
      {
        plugin = (
          nvim-treesitter.withPlugins (p: [
            p.tree-sitter-java
            p.tree-sitter-vim
            p.tree-sitter-typescript
            p.tree-sitter-tsx
            p.tree-sitter-lua
            p.tree-sitter-nix
            p.tree-sitter-python
          ])
        );
        config = "";
      }
      cmp-nvim-lsp
      cmp-buffer
      cmp-path
      cmp-cmdline
      luasnip
      cmp_luasnip
      vim-sleuth
      which-key-nvim
      plenary-nvim
      nvim-web-devicons
      nui-nvim
    ];
    extraPackages = with pkgs; [
      gcc
      stdenv.cc.cc
      typescript-language-server
      pyright
      rust-analyzer
    ];
    initLua = ''
      vim.g.mapleader = ' '
      vim.g.maplocalleader = ' '
      vim.opt.filetype = "on"
      vim.opt.termguicolors = true
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
      vim.opt.list = true
      vim.opt.listchars = {
        trail = '.',
        tab = '→·',
        lead = '.',
        leadmultispace = '.',
        nbsp = '␣',
        extends = '›',
        precedes = '‹',
      }

      vim.api.nvim_set_keymap('n', '<leader>o', ':Explore<CR>', {
        noremap = true,
        silent = true
      })

      vim.api.nvim_set_keymap('n', '<leader>e', ':Neotree toggle<CR>', {
        noremap = true,
        silent = true
      })

      vim.api.nvim_set_keymap('n', '<leader>h', ':bp<CR>', {
        noremap = true,
        silent = true
      })

      vim.api.nvim_set_keymap('n', '<leader>l', ':bn<CR>', {
        noremap = true,
        silent = true
      })

      vim.api.nvim_set_keymap('n', '<leader>C', ':CodeCompanionChat<CR>', {
        noremap = true,
        silent = true
      })

      vim.api.nvim_set_keymap('n', '<C-h>', '<C-w>h', { noremap = true, silent = true })
      vim.api.nvim_set_keymap('n', '<C-j>', '<C-w>j', { noremap = true, silent = true })
      vim.api.nvim_set_keymap('n', '<C-k>', '<C-w>k', { noremap = true, silent = true })
      vim.api.nvim_set_keymap('n', '<C-l>', '<C-w>l', { noremap = true, silent = true })

      vim.api.nvim_create_autocmd('LspAttach', {
        callback = function(args)
          local client = vim.lsp.get_client_by_id(args.data.client_id)
          print("Attached LSP client: " .. client.name)
          local opts = { buffer = args.buf }
          vim.keymap.set('n', 'gd', vim.lsp.buf.definition, opts)
          vim.keymap.set('n', 'K', vim.lsp.buf.hover, opts)
          vim.keymap.set('n', '<leader>rn', vim.lsp.buf.rename, opts)
          vim.keymap.set('n', '<leader>x', vim.diagnostic.setloclist, opts)
        end
      })

      vim.diagnostic.config({
        virtual_text = true, -- Show diagnostics inline (on the same line)
        signs = true,        -- Show signs in the sign column
        underline = true,    -- Underline problematic code
        update_in_insert = false, -- Update diagnostics only in normal mode
        severity_sort = true, -- Sort diagnostics by severity
      })
    '';
  };
}
