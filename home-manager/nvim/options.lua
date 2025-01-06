local opt = vim.opt -- for conciseness

-- format on save
vim.cmd([[autocmd BufWritePre * lua vim.lsp.buf.format()]])

-- random stuff
opt.showcmd = true -- shows command in the bottom
opt.laststatus = 2 -- always show status line
-- opt.autowrite = true  -- basically autosave
opt.cursorline = true -- line at cursor position
-- opt.autoread = true   -- refresh file if it has been modified outside of vim

-- use spaces for tabs
opt.tabstop = 2
opt.shiftwidth = 2
opt.shiftround = true
opt.expandtab = true

-- show line numbers
opt.number = true
opt.relativenumber = true

-- line wrapping
opt.wrap = false

-- search settings
opt.ignorecase = true
opt.smartcase = true

-- appearance
opt.termguicolors = true
opt.background = "dark"
opt.signcolumn = "yes"

-- backspace
opt.backspace = "2"

-- clipboard
opt.clipboard:append("unnamedplus")

-- split windows
opt.splitright = true
opt.splitbelow = true

-- turn off keybind timeout
-- opt.timeout = false
-- opt.ttimeout = false

-- override filetypes
vim.api.nvim_create_augroup("FileTypeOverrides", { clear = true })
vim.api.nvim_create_autocmd({ "BufRead", "BufNewFile" }, {
	pattern = "*.typ",
	callback = function()
		vim.opt.filetype = "typst"
	end,
	group = "FileTypeOverrides",
})
vim.api.nvim_create_autocmd({ "BufRead", "BufNewFile" }, {
	pattern = "*.pro",
	callback = function()
		vim.opt.filetype = "prolog"
	end,
	group = "FileTypeOverrides",
})
