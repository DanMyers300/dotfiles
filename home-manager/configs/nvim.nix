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
    #package = unstable.neovim-unwrapped;
    viAlias = true;
    vimAlias = true;
    plugins = with unstable.vimPlugins; [
      {
        plugin = nvim-lspconfig;
        config = ''
          lua << EOF
          -- Define/override configs for servers
          vim.lsp.config("ts_ls", {})

          vim.lsp.config("omnisharp", {
            cmd = { "dotnet", "OmniSharp.dll" },
            root_dir = vim.fs.dirname, -- optional custom root logic
            capabilities = vim.lsp.protocol.make_client_capabilities(),
          })

          -- Enable (auto start) them
          vim.lsp.enable("ts_ls")
          vim.lsp.enable("omnisharp")
          EOF'';
      }
      {
        plugin = mason-nvim;
        config = ''
          lua << EOF
            require("mason").setup()
          EOF'';
      }
      {
        plugin = mason-lspconfig-nvim;
        config = ''
          lua << EOF
          require("mason-lspconfig").setup({
            ensure_installed = { "omnisharp" },
          })
          EOF'';
      }
      {
        plugin = pkgs.rust-analyzer;
        config = ''
          lua << EOF
          vim.lsp.config("rust_analyzer", {
            settings = {
              ["rust-analyzer"] = {
                diagnostics = {
                  enable = true,
                },
                checkOnSave = {
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
          EOF'';
      }
      {
        plugin = nvim-cmp;
        config = ''
          lua << EOF
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
          EOF'';
      }
      #{
      #  plugin = codecompanion-nvim;
      #  config = ''
      #  lua << EOF
      #  require("codecompanion").setup({
      #    adapters = {
      #      http = {
      #        opts = {show_defaults = false,},
      #        ollama_adapter = function()
      #          return require("codecompanion.adapters").extend("ollama", {
      #            name = "gemma3:12b",
      #            schema = {
      #              model = {
      #                default = "gemma3:12b",
      #              },
      #              num_ctx = {
      #                default = 16384,
      #              },
      #              num_predict = {
      #                default = -1,
      #              },
      #            },
      #          })
      #        end,
      #      },
      #    },
      #    strategies = {
      #      chat = {
      #        adapter = "ollama_adapter",
      #      },
      #      inline = {
      #        adapter = "ollama_adapter",
      #      },
      #      cmd = {
      #        adapter = "ollama_adapter",
      #      }
      #    },
      #  })
      #  EOF'';
      #}
      {
        plugin = (
          nvim-treesitter.withPlugins (p: [
            p.tree-sitter-java
            p.tree-sitter-vim
            p.tree-sitter-typescript
            p.tree-sitter-tsx
            p.tree-sitter-lua
            p.tree-sitter-nix
            p.tree-sitter-c-sharp
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
    ];
    extraPackages = with pkgs; [
      gcc
      stdenv.cc.cc
      nodePackages.typescript-language-server
      rust-analyzer
    ];
    extraLuaConfig = ''
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

      vim.api.nvim_create_autocmd('LspAttach', {
        callback = function(args)
          local client = vim.lsp.get_client_by_id(args.data.client_id)
          print("Attached LSP client: " .. client.name)
          local opts = { buffer = args.buf }
          vim.keymap.set('n', 'gd', vim.lsp.buf.definition, opts)
          vim.keymap.set('n', 'K', vim.lsp.buf.hover, opts)
          vim.keymap.set('n', '<leader>rn', vim.lsp.buf.rename, opts)
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
