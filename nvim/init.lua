-- LUA CONFIG FROM HERE
keyset = vim.keymap.set
set = vim.o
options = { noremap = true, silent = true }

-- <MAPPINGS>
vim.g.mapleader = ','
-- keyset('n', 'K', [[o-<Space>]], options)
keyset('n', '<C-F>', [[:vimgrep]], options)
keyset('n', '<leader>t', [[:ToggleTerm<cr>]], options)
keyset('n', '<C-Q>', [[ciw]], options)
keyset('n', '<leader>ff', '<cmd>Telescope find_files<cr>', options)
keyset('n', '<leader>fg', '<cmd>Telescope live_grep<cr>', options)
keyset('n', '<leader>fb', '<cmd>Telescope buffers<cr>', options)
keyset('t', '<esc>', [[<C-\><C-n>]], options)
keyset('n', '<leader>yt', [[:tabnew<space>]], options)

-- <SETS DEFAULTS>
set.background = 'dark'
-- Some servers have issues with backup files, see #649
set.nowritebackup = true
-- Having longer updatetime (default is 4000 ms = 4s) leads to noticeable
-- delays and poor user experience
set.updatetime = 300

-- Always show the signcolumn, otherwise it would shift the text each time
-- diagnostics appear/become resolved
set.signcolumn = 'yes'

-- Disable compatibility with vi which can cause unexpected issues.
set.nocompatible = true
set.filetype = 'on'

-- Enable plugins and load plugin for the detected file type.
set.filetypeplugin = 'on'

-- Load an indent file for the detected file type.
set.filetypeindent = 'on'

set.syntax = 'on'
set.number = true
set.cursorline = true
set.cursorcolumn = true

-- Enable auto completion menu after pressing TAB.
set.wildmenu = true
set.shiftwidth = 4

-- set.tab width to 4 columns.
set.tabstop = 4

-- Use space characters instead of tabs.
set.expandtab = true

-- Do not save backup files.
set.nobackup = true

-- Do not let cursor scroll below or above N number of lines when scrolling.
set.scrolloff = 10
set.wrap = true

-- While searching though a file incrementally highlight matching characters as you type.
set.incsearch = true
set.ignorecase = true

-- Override the ignorecase option if searching for capital letters.
-- This will allow you to search specifically for capital letters.
set.smartcase = true

-- Show partial command you type in the last line of the screen.
set.showcmd = true

-- Show the mode you are on the last line.
set.showmode = true

-- Show matching words during a search.
set.showmatch = true

-- Use highlighting when doing a search.
set.hlsearch = true
set.history=1000

-- There are certain files that we would never want to edit with Vim.
-- Wildmenu will ignore files with these extensions.
set.wildignore='*.jpg,*.png,*.gif,*.pyc,*.exe,*.flv,*.img,*.xlsx'

set.wildmode= 'longest,list,full'
set.wildmenu = true

local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable", -- latest stable release
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

require('lazy').setup({

  'vim-airline/vim-airline',
  'tpope/vim-fugitive',
  'NLKNguyen/papercolor-theme',
  'rebelot/kanagawa.nvim',
  'neovim/nvim-lspconfig',
  'nvim-lua/plenary.nvim',
  'preservim/vim-markdown',
  {'nvim-treesitter/nvim-treesitter', [[do = ':TSUpdate']]},
  { 'nvim-telescope/telescope.nvim', tag = '0.1.4' },
  {'akinsho/toggleterm.nvim', version = "*", config = true},
  'hrsh7th/cmp-nvim-lsp',
    'hrsh7th/cmp-buffer',
    'hrsh7th/cmp-path',
    'hrsh7th/cmp-cmdline',
    'hrsh7th/nvim-cmp',
    {
	"L3MON4D3/LuaSnip",
	version = "v2.*", 
	build = "make install_jsregexp"
},
{
  "iamcco/markdown-preview.nvim",
  cmd = { "MarkdownPreviewToggle", "MarkdownPreview", "MarkdownPreviewStop" },
  build = "cd app && yarn install",
  init = function()
    vim.g.mkdp_filetypes = { "markdown" }
  end,
  ft = { "markdown" },
},
  })

vim.cmd([[colorscheme kanagawa-wave]])

-- Global mappings.
-- See `:help vim.diagnostic.*` for documentation on any of the below functions
keyset('n', '<space>e', vim.diagnostic.open_float)
keyset('n', '<leader>.', vim.diagnostic.goto_prev)
keyset('n', '<leader>/', vim.diagnostic.goto_next)
keyset('n', '<space>q', vim.diagnostic.setloclist)

-- Setting up auto complete
local cmp = require'cmp'
cmp.setup({
    snippet = {
      -- REQUIRED - you must specify a snippet engine
      expand = function(args)
        require('luasnip').lsp_expand(args.body) -- For `luasnip` users.
      end,
    },
    window = {
       completion = cmp.config.window.bordered(),
       documentation = cmp.config.window.bordered(),
    },
    mapping = cmp.mapping.preset.insert({
      ['<C-b>'] = cmp.mapping.scroll_docs(-4), -- Dunno what this is
      ['<C-f>'] = cmp.mapping.scroll_docs(4),
      ['<C-Space>'] = cmp.mapping.complete(),
      ['<C-e>'] = cmp.mapping.abort(),
      ['<CR>'] = cmp.mapping.confirm({ select = true }), -- Accept currently selected item. Set `select` to `false` to only confirm explicitly selected items.
    }),
    sources = cmp.config.sources({
      { name = 'nvim_lsp' },
      { name = 'luasnip' },
    }, {
      { name = 'buffer' },
    })
  })

  -- Use buffer source for `/` and `?` (if you enabled `native_menu`, this won't work anymore).
  -- This is really nice for pattern matching and stuff, not having to type it all out
  cmp.setup.cmdline({ '/', '?' }, {
    mapping = cmp.mapping.preset.cmdline(),
    sources = {
      { name = 'buffer' }
    }
  })

  -- Use cmdline & path source for ':' (if you enabled `native_menu`, this won't work anymore).
  -- Useful for knowing all the commands
  cmp.setup.cmdline(':', {
    mapping = cmp.mapping.preset.cmdline(),
    sources = cmp.config.sources({
      { name = 'path' }
    }, {
      { name = 'cmdline' }
    })
  })

  -- Set up lspconfig.
  local capabilities = require('cmp_nvim_lsp').default_capabilities()
  require('lspconfig')['ruff_lsp'].setup {
    capabilities = capabilities
}
  require'lspconfig'.pyright.setup{
    capabilities = capabilities
}
  require'lspconfig'.bashls.setup{}
--   require('lspconfig')['bash_language_server'].setup{
--     capabilities = capabilities
-- }
