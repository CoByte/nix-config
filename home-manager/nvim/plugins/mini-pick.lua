local minipick = require("mini.pick")
local wk = require("which-key")

minipick.setup({
	mappings = {
		caret_left = "<C-h>",
		caret_right = "<C-l>",

		move_down = "<C-j>",
		move_up = "<C-k>",
	},

	options = {
		content_from_bottom = true,
	},
})

local pick = _G["MiniPick"]

wk.add({
	{ "<leader>f", pick.builtin.files, desc = "Files" },
})

wk.add({
	{ "<leader>Fb", pick.builtin.buffers, desc = "Buffers" },
	{ "<leader>Fs", pick.builtin.grep_live, desc = "Live" },
})
