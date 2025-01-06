local treesitter = require("nvim-treesitter.configs")

-- Treesitter has issues parsing ruby and it does weird things with auto
-- indent. This is a shitty fix, but it works.
vim.cmd("autocmd FileType ruby setlocal indentkeys-=.")

treesitter.setup({
	-- A list of parser names, or "all"
	ensure_installed = {
		"c",
		"lua",
		"rust",
		"vim",
		"zig",
		-- http and json needed for rest
		"http",
		"json",
		"javascript",
		"css",
	},

	-- Install parsers synchronously (only applied to 'ensure_installed')
	sync_install = false,
	auto_install = true,
	highlight = {
		enable = true,
	},
	indent = { enable = true },
	autotag = { enable = true },
})
