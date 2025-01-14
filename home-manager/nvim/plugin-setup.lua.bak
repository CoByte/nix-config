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
	-- luarocks (lua package managed)
	-- {
	-- 	"vhyrro/luarocks.nvim",
	-- 	priority = 1000, -- Very high priority is required, luarocks.nvim should run as the first plugin in your config.
	-- 	config = true,
	-- 	opts = {
	-- 		rocks = { "lua-curl", "nvim-nio", "mimetypes", "xml2lua" },
	-- 		-- luarocks_build_args = { "CURL_DIR=/usr/include/x86_64-linux-gnu/" },
	-- 	},
	-- },

	-- themeing
	"ellisonleao/gruvbox.nvim",
	"nvim-lualine/lualine.nvim",
	{
		"akinsho/bufferline.nvim",
		version = "v3.*",
		dependencies = {
			"nvim-tree/nvim-web-devicons",
		},
	},

	-- file exploring
	"nvim-tree/nvim-tree.lua",

	-- treesitter
	{
		"nvim-treesitter/nvim-treesitter",
		build = ":TSUpdate",
	},

	-- fuzzy finding
	{
		"nvim-telescope/telescope-fzf-native.nvim",
		build = "make",
	},
	{
		"nvim-telescope/telescope.nvim",
		branch = "0.1.x",
		dependencies = {
			"nvim-lua/plenary.nvim",
		},
	},
	"nvim-telescope/telescope-ui-select.nvim",

	-- which key
	{
		"folke/which-key.nvim",
		init = function()
			vim.o.timeout = true
			vim.o.timeoutlen = 300
		end,
	},

	-- tabs
	"christoomey/vim-tmux-navigator",
	"szw/vim-maximizer",

	-- useful stuff
	"kylechui/nvim-surround",
	"vim-scripts/ReplaceWithRegister",
	"numToStr/Comment.nvim",
	"smjonas/inc-rename.nvim",
	"windwp/nvim-autopairs",
	"windwp/nvim-ts-autotag",

	-- REST requests (broken for some reason)
	-- {
	-- 	"rest-nvim/rest.nvim",
	-- 	dependencies = {
	-- 		"nvim-lua/plenary.nvim",
	-- 		"luarocks.nvim",
	-- 	},
	-- 	config = function()
	-- 		require("rest-nvim").setup()
	-- 	end,
	-- },

	-- autocompletion
	"hrsh7th/nvim-cmp",
	"hrsh7th/cmp-buffer",
	"hrsh7th/cmp-path",

	-- snippets
	"L3MON4D3/LuaSnip",
	"saadparwaiz1/cmp_luasnip",
	"rafamadriz/friendly-snippets",

	-- helps with editing nvim config
	"folke/neodev.nvim",

	-- managing/installing lsp servers, linters, formatters
	"williamboman/mason.nvim",
	"williamboman/mason-lspconfig.nvim",

	-- lsp configuration
	"neovim/nvim-lspconfig",
	"hrsh7th/cmp-nvim-lsp",
	"onsails/lspkind.nvim",

	-- assorted lang stuff
	{
		"ziglang/zig.vim",
	},
	{
		"ShinKage/idris2-nvim",
		dependencies = {
			"neovim/nvim-lspconfig",
			"MunifTanjim/nui.nvim",
		},
	},

	{
		"chomosuke/typst-preview.nvim",
		lazy = false, -- or ft = 'typst'
		version = "1.0.*",
		build = function()
			require("typst-preview").update()
		end,
	},

	-- testing
	{
		"nvim-neotest/neotest",
		dependencies = {
			"nvim-lua/plenary.nvim",
			"nvim-neotest/nvim-nio",
			"antoinemadec/FixCursorHold.nvim",
			"nvim-treesitter/nvim-treesitter",

			-- vim-test support
			"vim-test/vim-test",
			"nvim-neotest/neotest-vim-test",

			-- plenary for whatever reason
			"nvim-neotest/neotest-plenary",

			-- test runners
			"nvim-neotest/neotest-python",
		},
	},

	-- formatting and linting
	"jose-elias-alvarez/null-ls.nvim",
	"jayp0521/mason-null-ls.nvim",

	-- git signs
	"lewis6991/gitsigns.nvim",
})
