local jk = require("better_escape")

local esc = {
	j = { k = "<Esc>" },
	k = { j = "<Esc>" },
}

jk.setup({
	timeout = 100,
	default_mappings = false,
	mappings = {
		i = esc,
		v = esc,
	},
})
