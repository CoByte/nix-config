local files = require("mini.files")
local wk = require("which-key")

files.setup({
	mappings = {
		go_in_plus = "l",
		go_in = "L",
		close = "<Esc>",
	},
})

local f = _G["MiniFiles"]

local function open_cwd()
	f.open(nil, false)
end

local function open_current()
	f.open(vim.api.nvim_buf_get_name(0), false)
	f.reveal_cwd()
end

wk.add({
	{ "<leader>e", open_cwd, desc = "CWD" },
	{ "<leader>E", open_current, desc = "current" },
})
