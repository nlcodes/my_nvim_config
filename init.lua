-- Bootstrap lazy.nvim
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
  local lazyrepo = "https://github.com/folke/lazy.nvim.git"
  local out = vim.fn.system({ "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath })
  if vim.v.shell_error ~= 0 then
    vim.api.nvim_echo({
      { "Failed to clone lazy.nvim:\n", "ErrorMsg" },
      { out, "WarningMsg" },
      { "\nPress any key to exit..." },
    }, true, {})
    vim.fn.getchar()
    os.exit(1)
  end
end
vim.opt.rtp:prepend(lazypath)

-- Copy to system clipboard; install wl-clipboard dependency
vim.opt.clipboard = 'unnamedplus'

-- Basic settings
vim.o.number = true -- Line numbers
vim.o.relativenumber = false -- Disable relative line numbers
vim.o.tabstop = 2 -- Number of spaces a tab represents
vim.o.shiftwidth = 2 -- Number of spaces for each indentation
vim.o.expandtab = true -- Convert tabs to spaces
vim.o.smartindent = true -- Automatically indent new lines
vim.o.wrap = false -- Disable line wrapping
vim.cmd.syntax("on") -- Enable syntax highlighting

-- Set mapleader and maplocalleader
vim.g.mapleader = " "
vim.g.maplocalleader = "\\"

-- Setup lazy.nvim
require("lazy").setup({
  spec = {

    -- File explorer
    {
      'nvim-tree/nvim-tree.lua',
      dependencies = { 'nvim-tree/nvim-web-devicons' },
      config = function()
        require('nvim-tree').setup {}
        -- Optional: Open the tree when entering Neovim
        -- Use :NvimTreeToggle to toggle file tree
        -- require('nvim-tree.api').tree.open()
      end,
    },

    -- Autocompletion
    {
      'hrsh7th/nvim-cmp',
      dependencies = {
        'hrsh7th/cmp-nvim-lsp',
        'hrsh7th/cmp-buffer',
        'hrsh7th/cmp-path',
        'L3MON4D3/LuaSnip',
        'saadparwaiz1/cmp_luasnip',  -- Snippet completions
      },
      config = function()
        -- Set up nvim-cmp
        local cmp = require('cmp')
        cmp.setup({
          snippet = {
            -- REQUIRED - you must specify a snippet engine
            expand = function(args)
              require('luasnip').lsp_expand(args.body) -- For `luasnip` users
            end,
          },
          mapping = cmp.mapping.preset.insert({
            ['<C-b>'] = cmp.mapping.scroll_docs(-4),
            ['<C-f>'] = cmp.mapping.scroll_docs(4),
            ['<C-Space>'] = cmp.mapping.complete(),
            ['<C-e>'] = cmp.mapping.abort(),
            ['<CR>'] = cmp.mapping.confirm({ select = true }), -- Accept currently selected item
          }),
          sources = cmp.config.sources({
            { name = 'nvim_lsp' },
            { name = 'luasnip' }, -- For luasnip users
          }, {
            { name = 'buffer' },
          })
        })
      end,
    },

    -- Language Server Protocol configurations
    {
      'neovim/nvim-lspconfig',
      dependencies = { 'hrsh7th/cmp-nvim-lsp' },
      config = function()
        -- Set up lspconfig
        local lspconfig = require('lspconfig')

        -- Set up capabilities for nvim-cmp
        local capabilities = require('cmp_nvim_lsp').default_capabilities()

        -- Set up servers
        lspconfig.clangd.setup{
          capabilities = capabilities,
        }

        -- Add additional language servers here if needed
      end,
    },
  },
})

-- Enable true color support
vim.opt.termguicolors = true  

-- Set the colorscheme (outside of lazy.nvim setup)
vim.cmd.colorscheme("neo_srcery")

-- Override background color for normal highlight group; sets bg to black
vim.api.nvim_set_hl(0, "Normal", { bg = "#000000" })
