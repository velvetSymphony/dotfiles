-- Vimming

vim.cmd([[
    let g:gitblame_enabled = 0
    let g:vim_markdown_edit_url_in = 'tab'
    let g:vim_markdown_folding_disabled = 1
    highlight ExtraWhitespace ctermbg=red guibg=red
    match ExtraWhitespace /\s\+$/
]])

-- LUA CONFIG FROM HERE
keyset = vim.keymap.set
set = vim.o
options = { noremap = true, silent = true }

-- <MAPPINGS>
vim.g.mapleader = ","
-- keyset('n', 'K', [[o-<Space>]], options)
keyset("n", "<C-F>", [[:vimgrep]], options)
keyset("n", "<leader>t", [[:ToggleTerm<cr>]], options)
keyset("n", "<C-Q>", [[ciw]], options)
keyset("n", "<leader>ff", "<cmd>:Pick files<cr>", options)
keyset("n", "<leader>l", [[:set hlsearch<cr>]], options)
keyset("n", "<leader>fg", "<cmd>Telescope live_grep<cr>", options)
keyset("n", "<leader>fb", "<cmd>Telescope buffers<cr>", options)
keyset("t", "<esc>", [[<C-\><C-n>]], options)
keyset("n", "<leader>yt", [[:tabnew<space>]], options)
keyset("n", "]g", vim.diagnostic.goto_next)
keyset("n", "[g", vim.diagnostic.goto_prev)

-- <SETS DEFAULTS>
set.background = "dark"
-- Having longer updatetime (default is 4000 ms = 4s) leads to noticeable
-- delays and poor user experience
set.updatetime = 300
-- Always show the signcolumn, otherwise it would shift the text each time
-- diagnostics appear/become resolved
set.signcolumn = "yes"
-- Disable compatibility with vi which can cause unexpected issues.
-- set.nocompatible = true
set.filetype = "on"
-- Enable plugins and load plugin for the detected file type.
-- set.filetypeplugin = 'on'
-- Load an indent file for the detected file type.
-- set.filetypeindent = 'on'
set.syntax = "on"
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
-- Use highlighting when doing a search.
set.hlsearch = true
set.history = 1000
-- There are certain files that we would never want to edit with Vim.
-- Wildmenu will ignore files with these extensions.
set.wildignore = "*.jpg,*.png,*.gif,*.pyc,*.exe,*.flv,*.img,*.xlsx"
set.wildmode = "longest,list,full"
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

require("lazy").setup({
	"NLKNguyen/papercolor-theme",
	"rebelot/kanagawa.nvim",
	"preservim/nerdtree",
	"nvim-lua/plenary.nvim",
	"f-person/git-blame.nvim", -- to be replaced by gitsigns
	"godlygeek/tabular",
	"preservim/vim-markdown",
	"tpope/vim-apathy", -- The lovely gx and gf
	{
		"lewis6991/gitsigns.nvim",
		opts = {
			signs = {
				add = { text = "┃" },
				change = { text = "┃" },
				delete = { text = "_" },
				topdelete = { text = "‾" },
				changedelete = { text = "~" },
				untracked = { text = "┆" },
			},
			signs_staged = {
				add = { text = "┃" },
				change = { text = "┃" },
				delete = { text = "_" },
				topdelete = { text = "‾" },
				changedelete = { text = "~" },
				untracked = { text = "┆" },
			},
			signs_staged_enable = true,
			signcolumn = true, -- Toggle with `:Gitsigns toggle_signs`
			numhl = false, -- Toggle with `:Gitsigns toggle_numhl`
			linehl = false, -- Toggle with `:Gitsigns toggle_linehl`
			word_diff = false, -- Toggle with `:Gitsigns toggle_word_diff`
			watch_gitdir = {
				follow_files = true,
			},
			auto_attach = true,
			attach_to_untracked = false,
			current_line_blame = false, -- Toggle with `:Gitsigns toggle_current_line_blame`
			current_line_blame_opts = {
				virt_text = true,
				virt_text_pos = "eol", -- 'eol' | 'overlay' | 'right_align'
				delay = 1000,
				ignore_whitespace = false,
				virt_text_priority = 100,
				use_focus = true,
			},
			current_line_blame_formatter = "<author>, <author_time:%R> - <summary>",
			sign_priority = 6,
			update_debounce = 100,
			status_formatter = nil, -- Use default
			max_file_length = 40000, -- Disable if file is longer than this (in lines)
			preview_config = {
				-- Options passed to nvim_open_win
				style = "minimal",
				relative = "cursor",
				row = 0,
				col = 1,
			},
			config = function(_, opts)
				require("gitsigns").setup(opts)
			end,
		},
	},
	{
		"echasnovski/mini.statusline",
		version = false,
		opts = {},
		config = function(_, opts)
			require("mini.statusline").setup(opts)
		end,
	},
	{
		"folke/noice.nvim",
		event = "VeryLazy",
		opts = {
			-- add any options here
		},
		dependencies = {
			-- if you lazy-load any plugin below, make sure to add proper `module="..."` entries
			"MunifTanjim/nui.nvim",
			-- OPTIONAL:
			--   `nvim-notify` is only needed, if you want to use the notification view.
			--   If not available, we use `mini` as the fallback
			"rcarriga/nvim-notify",
		},
	},
	{ "akinsho/toggleterm.nvim", version = "*", config = true }, -- Need to use this more often, can't justify keeping it as of now
	{ "nvim-treesitter/nvim-treesitter", indent = true },
	{
		"echasnovski/mini.pick",
		version = false,
	},
	{
		"saghen/blink.cmp",
		event = "VimEnter",
		dependencies = {
			-- Snippet Engine & its associated nvim-cmp source
			{
				"L3MON4D3/LuaSnip",
				version = "2.*",
				build = (function()
					-- Build Step is needed for regex support in snippets.
					-- This step is not supported in many windows environments.
					-- Remove the below condition to re-enable on windows.
					if vim.fn.has("win32") == 1 or vim.fn.executable("make") == 0 then
						return
					end
					return "make install_jsregexp"
				end)(),
				dependencies = {
					-- `friendly-snippets` contains a variety of premade snippets.
					--    See the README about individual language/framework/plugin snippets:
					--    https://github.com/rafamadriz/friendly-snippets
					-- {
					--   'rafamadriz/friendly-snippets',
					--   config = function()
					--     require('luasnip.loaders.from_vscode').lazy_load()
					--   end,
					-- },
				},
				opts = {},
			},
			"folke/lazydev.nvim",
			"rafamadriz/friendly-snippets",
		},
		--- @module 'blink.cmp'
		--- @type blink.cmp.Config
		-- optional: provides snippets for the snippet source
		-- use a release tag to download pre-built binaries
		version = "1.*",
		opts = {
			-- All presets have the following mappings:
			-- C-space: Open menu or open docs if already open
			-- C-n/C-p or Up/Down: Select next/previous item
			-- C-e: Hide menu
			-- C-k: Toggle signature help (if signature.enabled = true)
			-- See :h blink-cmp-config-keymap for defining your own keymap
			keymap = {
				preset = "enter",
				["<C-space>"] = {
					function(cmp)
						cmp.show({ providers = { "snippets" } })
					end,
				},
				-- ["<Right>"] = { "show_signature", "fallback" },
			},
			appearance = {
				-- 'mono' (default) for 'Nerd Font Mono' or 'normal' for 'Nerd Font'
				-- Adjusts spacing to ensure icons are aligned
				nerd_font_variant = "mono",
			},
			-- (Default) Only show the documentation popup when manually triggered
			completion = {
				documentation = { auto_show = true, auto_show_delay_ms = 500 },
				menu = {
					draw = {
						components = {
							kind_icon = {
								text = function(ctx)
									local kind_icon, _, _ = require("mini.icons").get("lsp", ctx.kind)
									return kind_icon
								end,
								-- (optional) use highlights from mini.icons
								highlight = function(ctx)
									local _, hl, _ = require("mini.icons").get("lsp", ctx.kind)
									return hl
								end,
							},
							kind = {
								-- (optional) use highlights from mini.icons
								highlight = function(ctx)
									local _, hl, _ = require("mini.icons").get("lsp", ctx.kind)
									return hl
								end,
							},
						},
					},
				},
			},
			-- Default list of enabled providers defined so that you can extend it
			-- elsewhere in your config, without redefining it, due to `opts_extend`
			sources = {
				default = { "lsp", "path", "snippets", "buffer", "lazydev" },
				providers = {
					lazydev = { module = "lazydev.integrations.blink", score_offset = 100 },
				},
			},
			cmdline = {
				keymap = { preset = "default" },
				completion = { menu = { auto_show = true }, ghost_text = { enabled = true } },
			},
			snippets = { preset = "luasnip" },
			fuzzy = { implementation = "prefer_rust_with_warning" },
			-- Shows a signature help window while you type arguments for a function
			signature = { enabled = true },
		},
		opts_extend = { "sources.default" },
	},
	{
		"neovim/nvim-lspconfig",
		dependencies = { "saghen/blink.cmp" },
		--		vim.lsp.config("powershell_es", {
		--			bundle_path = "/Users/abhishekchandrasekar/Downloads/PowerShellEditorServices",
		--			cmd = {
		--				"pwsh",
		--				"-NoLogo",
		--				"-NoProfile",
		--				"-Command",
		--				"/Users/abhishekchandrasekar/Downloads/PowerShellEditorServices/PowerShellEditorServices/Start-EditorServices.ps1 -SessionDetailsPath /Users/abhishekchandrasekar/Downloads/PowerShellEditorServices/PowerShellEditorServices/session.json",
		--			},
		--		}),

		-- example using `opts` for defining servers
		opts = {
			servers = {
				yamlls = {
					settings = {
						yaml = {
							format = {
								"enable",
							},
							customTags = {
								"!And",
								"!If",
								"!Not",
								"!Equals",
								"!Or",
								"!FindInMap sequence",
								"!Base64",
								"!Cidr",
								"!Ref",
								"!Sub",
								"!GetAtt",
								"!GetAZs",
								"!ImportValue",
								"!Select",
								"!Select sequence",
								"!Split",
								"!Join sequence",
							},
						},
					},
				},
				pylsp = {},
				lua_ls = {},
				bashls = {},
				-- TODO: Add Terraform ls
				--				powershell_es = {},
			},
		},
		config = function(_, opts)
			local lspconfig = require("lspconfig")
			for server, config in pairs(opts.servers) do
				config.capabilities = require("blink.cmp").get_lsp_capabilities(config.capabilities)
				lspconfig[server].setup(config)
			end
		end,
	},
	{ -- Format
		"stevearc/conform.nvim",
		event = { "BufWritePre" },
		cmd = { "ConformInfo" },
		keys = {
			{
				"<leader>f",
				function()
					require("conform").format({ async = true, lsp_format = "fallback" })
				end,
				mode = "",
				desc = "[F]ormat buffer",
			},
		},
		opts = {
			-- Set to true to ignore errors
			ignore_errors = false,
			-- Map of treesitter language to filetype
			lang_to_ft = {
				-- bash = "sh",
			},
			-- Map of treesitter language to file extension
			-- A temporary file name with this extension will be generated during formatting
			-- because some formatters care about the filename.
			lang_to_ext = {
				bash = "sh",
				c_sharp = "cs",
				elixir = "exs",
				javascript = "js",
				json = "json",
				julia = "jl",
				latex = "tex",
				markdown = "md",
				python = "py",
				powershell = "ps1",
				ruby = "rb",
				rust = "rs",
				teal = "tl",
				typescript = "ts",
				terraform = "tf",
				yaml = "yaml",
			},
			-- Map of treesitter language to formatters to use
			-- (defaults to the value from formatters_by_ft)
			lang_to_formatters = {},
			notify_on_error = true,
			notify_no_formatters = true,
			format_on_save = {
				lsp_format = "fallback",
				timeout_ms = 500,
			},
			formatters_by_ft = {
				lua = { "stylua" },
				python = { "black" },
				markdown = { "prettier" },
				-- sh = { "shfmt" },
				bash = { "shfmt" },
				zsh = { "shfmt" },
				-- terraform = { "terraform fmt" },
				yaml = { "prettier" },
			},
		},
	},
	{ -- Highlight, edit, and navigate code
		"nvim-treesitter/nvim-treesitter",
		build = ":TSUpdate",
		main = "nvim-treesitter.configs",
		opts = {
			ensure_installed = {
				"bash",
				"c",
				"diff",
				"html",
				"lua",
				"luadoc",
				"markdown",
				"markdown_inline",
				"query",
				"vim",
				"vimdoc",
				"python",
				"powershell",
				"typescript",
				"javascript",
				"gitcommit",
				"yaml",
				"json",
				"html",
				"graphql",
				"dockerfile",
				"go",
				"puppet",
				"hcl",
			},
			-- Autoinstall languages that are not installed
			-- auto_install = true,
			highlight = {
				enable = true,
				-- Some languages depend on vim's regex highlighting system (such as Ruby) for indent rules.
				--  If you are experiencing weird indenting issues, add the language to
				--  the list of additional_vim_regex_highlighting and disabled languages for indent.
				additional_vim_regex_highlighting = { "ruby" },
			},
			indent = { enable = true, disable = { "ruby" } },
		},
		config = function(_, opts)
			-- [[ Configure Treesitter ]] See `:help nvim-treesitter`

			---@diagnostic disable-next-line: missing-fields
			require("nvim-treesitter.configs").setup(opts)

			-- There are additional nvim-treesitter modules that you can use to interact
			-- with nvim-treesitter. You should go explore a few and see what interests you:
			--
			--    - Incremental selection: Included, see `:help nvim-treesitter-incremental-selection-mod`
			--    - Show your current context: https://github.com/nvim-treesitter/nvim-treesitter-context
			--    - Treesitter + textobjects: https://github.com/nvim-treesitter/nvim-treesitter-textobjects
		end,
	},
	{ -- Render markdown from neovim
		"MeanderingProgrammer/render-markdown.nvim",
		dependencies = { "nvim-treesitter/nvim-treesitter", "echasnovski/mini.icons" }, -- if you use standalone mini plugins
		-- dependencies = { 'nvim-treesitter/nvim-treesitter', 'nvim-tree/nvim-web-devicons' }, -- if you prefer nvim-web-devicons
		---@module 'render-markdown'
		---@type render.md.UserConfig
		opts = {
			render_modes = { "n", "c", "t" },
		},
	},
})
vim.cmd([[colorscheme kanagawa]])

-- Global mappings.
-- See `:help vim.diagnostic.*` for documentation on any of the below functions
keyset("n", "<space>e", vim.diagnostic.open_float)
keyset("n", "<leader>.", vim.diagnostic.goto_prev)
keyset("n", "<leader>/", vim.diagnostic.goto_next)
keyset("n", "<space>q", vim.diagnostic.setloclist)

require("render-markdown").setup({
	completions = { blink = { enabled = true } },
})
require("mini.pick").setup()
require("noice").setup({
	lsp = {
		-- override markdown rendering so that **cmp** and other plugins use **Treesitter**
		override = {
			["vim.lsp.util.convert_input_to_markdown_lines"] = true,
			["vim.lsp.util.stylize_markdown"] = true,
			["cmp.entry.get_documentation"] = true, -- requires hrsh7th/nvim-cmp
		},
	},
	-- you can enable a preset for easier configuration
	presets = {
		bottom_search = true, -- use a classic bottom cmdline for search
		command_palette = true, -- position the cmdline and popupmenu together
		long_message_to_split = true, -- long messages will be sent to a split
		inc_rename = false, -- enables an input dialog for inc-rename.nvim
		lsp_doc_border = false, -- add a border to hover docs and signature help
	},
})
require("luasnip/loaders/from_vscode").lazy_load()
for _, path in ipairs(vim.api.nvim_get_runtime_file("lua/snippets/*.lua", true)) do
	loadfile(path)()
end
