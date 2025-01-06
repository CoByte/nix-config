vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1
vim.g.nvim_tree_respect_buf_cwd = 1

vim.opt.termguicolors = true

require("nvim-tree").setup({
	actions = {
		open_file = {
			window_picker = {
				enable = false,
			},
		},
	},
	filters = {
		dotfiles = true,
	},
	view = {
		side = "right",
	},
})

-- vim.keymap.set('n', '<c-n>', ':NvimTreeFindFileToggle<CR>')
