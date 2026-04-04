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

local function hidden_files()
	pick.builtin.cli({
		command = { "rg", "--files", "--hidden", "--glob", "!.git" },
	}, {
		source = {
			name = "Files",
		},
	})
end

wk.add({
	{ "<leader>f", hidden_files, desc = "Files" },
})

wk.add({
	{ "<leader>gb", pick.builtin.buffers, desc = "Buffers" },
	{ "<leader>gg", pick.builtin.grep_live, desc = "Live" },
})
