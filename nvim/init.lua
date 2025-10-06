Keyset = vim.keymap.set
Set = vim.o
Options = { noremap = true, silent = true }

-- <MAPPINGS>
vim.g.mapleader = " "
Keyset("n", "<C-f>", [[:vimgrep<space>]], Options)
Keyset("n", "<leader>ff", "<cmd>:Pick files<cr>", Options)
Keyset("t", "<esc>", [[<C-\><C-n>]], Options)
Keyset("n", "<TAB>", [[:tabnext<cr>]], Options)
Keyset("n", "<S-TAB>", [[:tabprevious<cr>]], Options)
Keyset("n", "<leader>l", [[:set hlsearch<cr>]], Options)
Keyset("n", "<leader>c", [[:set ignorecase!<cr>]], Options)
Keyset("n", "<leader>t", [[:tabnew<space>]], Options)
Keyset("n", "<leader>q", [[:q!<cr>]], Options)
Keyset("n", "<leader>w", [[:w<cr>]], Options)
Keyset("n", "<leader>l", [[:set nohlsearch!<cr>]], Options)
Keyset("n", "<leader>g", [[:GitBlameToggle<cr>]], Options)
Keyset("n", "<leader>v", [[:vsplit<cr>]], Options)
Keyset("n", "<leader>e", vim.diagnostic.open_float)
Keyset("n", "<leader>.", vim.diagnostic.goto_prev)
Keyset("n", "<leader>/", vim.diagnostic.goto_next)
Keyset("n", "<leader>d", vim.diagnostic.setloclist)
-- keyset("n", "<leader>Left", [[<C-w>h]], Options)
-- keyset("n", "<leader>Right", [[<C-w>l]], Options)

-- <SETS DEFAULTS>
Set.number = true
Set.messagesopt = "hit-enter,history:3000"
Set.cursorline = true
Set.cursorcolumn = true

-- "The length of time Vim waits after you stop typing before it triggers the plugin is governed by the setting updatetime.
-- This defaults to 4000 milliseconds which is rather too long. I recommend around 750 milliseconds but it depends on your system and your preferences. Note that in terminal Vim pre-7.4.427 an updatetime of less than approximately 1000 milliseconds can lead to random highlighting glitches; the lower the updatetime, the more glitches."
-- Reference: https://www.reddit.com/r/vim/comments/3ql651/what_do_you_set_your_updatetime_to/
Set.updatetime = 750
-- Always show the signcolumn, otherwise it would shift the text each time diagnostics appear/become resolved
-- https://www.reddit.com/r/neovim/comments/f04fao/my_biggest_vimneovim_wish_single_width_sign_column
Set.signcolumn = "yes:1"

Set.filetype = "on"

-- The file types are also used for syntax highlighting.  If the ":syntax on" command is used, the file type detection is installed too.  There is no need to do ":filetype on" after ":syntax on"
-- https://neovim.io/doc/user/filetype.html#%3Afiletype-indent-on
Set.syntax = "on"
Set.list = true
-- Set.listchars = { tab = '| ' }
-- https://www.reddit.com/r/neovim/comments/14xobx2/comment/jrorroe/?utm_source=share&utm_medium=web2x&context=3
Set.listchars = "trail:-,nbsp:+,tab:▏ "

-- Enable auto completion menu after pressing TAB.
-- https://stackoverflow.com/questions/9511253/how-to-effectively-use-vim-wildmenu
Set.wildmenu = true
Set.wildmode = "longest:full,full"
Set.wildignore = "*.jpg,*.png,*.gif,*.pyc,*.exe,*.flv,*.img,*.xlsx"

-- https://www.reddit.com/r/vim/comments/99ylz8/confused_about_the_difference_between_tabstop_and/
Set.shiftwidth = 4
Set.tabstop = 4
-- Use space characters instead of tabs.
Set.expandtab = true
-- Do not let cursor scroll below or above N number of lines when scrolling.
-- If the last line on your screen is, say 90. When your cursor is on line 70, the screen will start moving down further. If you have a lower value, it just means you'll remain on the "same" location for longer before moving.
Set.scrolloff = 10

-- word wrapping
Set.wrap = true
-- Just wrap at a complete word and not a random letter or midway in a word.
Set.linebreak = true
--- I may have misunderstood this option, as I don't see any indents.
Set.breakindent = true

-- Set.showbreak = "+++ "

-- searching a file incrementally highlight matching characters as you type.
Set.incsearch = true

-- I'd rather that this was a toggle.
-- set.ignorecase = true

-- Testing these, they may already be enabled due to a plugin I use.
-- And don't use set autoindent. It's not very intelligent, it just copies the indent from the previous line. It's the opposite of what you're trying to do.https://stackoverflow.com/questions/45108986/introduce-tab-in-new-line-while-creating-a-block-for-python-files-in-vim
-- Set.autoindent = true
-- Set.smartindent = true

-- Override the ignorecase option if searching pattern contains upper case characters.
-- This will allow you to search specifically for capital letters.
Set.smartcase = true
Set.showmode = true
Set.hlsearch = true
Set.history = 5000

-- https://neovim.io/doc/user/fold.html#_2.-fold-commands
Set.foldmethod = "manual"

-- Prepend 'lazypath' to the runtimepath (rtp) of neovim
-- See https://stackoverflow.com/questions/78660123/what-is-vim-loop-fs-stat
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
	vim.fn.system({
		"git",
		"clone",
		"--filter=blob:none",
		"https://github.com/folke/lazy.nvim.git",
		"--branch=stable",
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
	"preservim/vim-markdown",
	"tpope/vim-apathy", -- The lovely gx and gf
	"neovim/nvim-lspconfig",
	{ "nvim-treesitter/nvim-treesitter", indent = true },
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
		},
		config = function(_, opts)
			require("gitsigns").setup(opts)
		end,
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
		"echasnovski/mini.pick",
		version = false,
		opts = {},
		config = function(_, opts)
			require("mini.pick").setup(opts)
		end,
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
				dependencies = {},
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
		-- This will provide type hinting with LuaLS
		---@module "conform"
		---@type conform.setupOpts
		opts = {
			-- Set to true to ignore errors
			ignore_errors = true,
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
			-- REDO THIS BELOW
			-- format_on_save = {
			--  lsp_format = "fallback",
			--  timeout_ms = 500,
			-- },
			formatters_by_ft = {
				lua = { "stylua" },
				python = { "ruff_fix", "ruff_format", "ruff_organize_imports" },
				markdown = { "prettier" },
				-- sh = { "shfmt" },
				bash = { "shfmt" },
				-- zsh = { "shfmt" },
				terraform = { "terraform fmt" },
				hcl = { "terraform fmt" },
				yaml = { "prettier" },
				json = { "prettier" },
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
				additional_vim_regex_highlighting = { "ruby", "python" },
			},
			indent = { enable = true, disable = { "ruby", "python" } },
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
		-- cmd = { "ConformInfo" },
		keys = {
			{
				"<leader>r",
				function()
					-- require("render-markdown").format({ async = true, lsp_format = "fallback" })
					vim.cmd([[RenderMarkdown buf_toggle]])
				end,
				mode = "",
				desc = "Toggle Rendering markdown",
			},
		},
		-- dependencies = { 'nvim-treesitter/nvim-treesitter', 'nvim-tree/nvim-web-devicons' }, -- if you prefer nvim-web-devicons
		--		---@module 'render-markdown'
		--		---@type render.md.UserConfig
		opts = {
			render_modes = { "n", "c", "t" },
			completions = { blink = { enabled = true } },
			anti_conceal = { enabled = false },
		},
	},
})
-- Vimming

ExtraWhiteSpace = vim.cmd([[highlight ExtraWhitespace ctermbg=red guibg=red
match ExtraWhitespace /\s\+$/]])

Colourscheme = vim.cmd.colorscheme("kanagawa")

--vim.cmd([[autocmd FileType * set tabstop=4 softtabstop=4 shiftwidth=4 noexpandtab]])

-------------------------------------------------------------------------------
-- Functions
-------------------------------------------------------------------------------

-- x = vim.api.nvim_open_win(0, true, { relative = "win", width = 60, height = 30, bufpos = { 50, 50 } })

-- open_window_centred = function()
-- 	local height = vim.o.lines
-- 	local width = vim.o.columns
-- 	local desired_width = math.floor(width * 0.75)
-- 	local desired_height = math.floor(height * 0.75)
-- 	local row = math.floor((height - desired_height) / 2)
-- 	local col = math.floor((width - desired_width) / 2)
--
-- 	-- I don't think I need this
-- 	--local buf = vim.api.nvim_create_buf(false, true)
-- 	vim.api.nvim_open_win(0, true, {
-- 		relative = "editor",
-- 		width = desired_width,
-- 		height = desired_height,
-- 		row = row,
-- 		col = col,
-- 		border = "rounded",
-- 		title = "Terminal!",
-- 		title_pos = "left",
-- 	})
-- 	vim.cmd.terminal()
-- end
--
-- open_window_centred()

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
	basedpyright = {},
	lua_ls = {
		settings = {
			cmd = { "lua-language-server" },
			filetypes = { "lua" },
			root_markers = {
				".luarc.json",
				".luarc.jsonc",
				".luacheckrc",
				".stylua.toml",
				"stylua.toml",
				"selene.toml",
				"selene.yml",
				".git",
			},
			-- Do not send telemetry data containing a randomized but unique identifier
			telemetry = {
				enable = false,
			},
			diagnostics = {
				globals = { "vim" },
			},
		},
	},
	bashls = {},
	jsonls = {},
	--ruff = {
	--	settings = {
	--		configuration = "~/ruff.toml",
	--	},
	--},
	-- TODO: Add Terraform ls
	--				powershell_es = {},
}
-- deprecated, added quickfix below
-- config = function(_, opts)
-- 	local lspconfig = require("lspconfig")
-- 	for server, config in pairs(opts.servers) do
-- 		config.capabilities = require("blink.cmp").get_lsp_capabilities(config.capabilities)
-- 		lspconfig[server].setup(config)
-- 	end
-- end,
for server, config in pairs(servers) do
	-- config.capabilities = require("blink.cmp").get_lsp_capabilities(config.capabilities)
	vim.lsp.config(server, {
		-- everything should be in path so shouldn't need below command
		-- see https://github.com/neovim/nvim-lspconfig/blob/master/doc/configs.md#ruff
		settings = server.settings,
	})
	vim.lsp.enable(server)
end

-- Show fold help commands
function show_fold_commands()
    -- add shortcut file to the buffer
 	local height = vim.o.lines
 	local width = vim.o.columns
 	local desired_width = math.floor(width * 0.45)
 	local desired_height = math.floor(height * 0.45)
 	local row = math.floor((height - desired_height) / 2)
 	local col = math.floor((width - desired_width) / 2)

 	local buf = vim.api.nvim_create_buf(false, true)
    vim.api.nvim_buf_call(buf, function() vim.cmd('edit ~/.config/nvim/fold-commands') end)
 	vim.api.nvim_open_win(buf, true, {
 		relative = "editor",
 		width = desired_width,
 		height = desired_height,
 		row = row,
 		col = col,
 		border = "rounded",
        style = "minimal",
 		title = "Fold commands",
 		title_pos = "center",
 	})
end
-- Keyset("n", "<leader>z", show_fold_commands())
--
-- TODOS:
-- Autocommands to change certain keybinds when editing different filetypes (markdown = more fold options available with leader keys?)
-- Complete above functions and test them
-- Something else I forgot about...
