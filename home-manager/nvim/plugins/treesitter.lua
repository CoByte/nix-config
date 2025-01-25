local treesitter = require("nvim-treesitter.configs")

-- Treesitter has issues parsing ruby and it does weird things with auto
-- indent. This is a shitty fix, but it works.
vim.cmd("autocmd FileType ruby setlocal indentkeys-=.")

treesitter.setup({
	-- don't ever try to install things (it is evil)
	sync_install = false,
	auto_install = false,
	highlight = {
		enable = true,
	},
	indent = { enable = true },
	autotag = { enable = true },
})
