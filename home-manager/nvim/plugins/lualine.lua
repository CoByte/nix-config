local lualine = require("lualine")

local function window()
	return vim.api.nvim_win_get_number(0)
end

lualine.setup({
	options = {
		icons_enabled = true,
		theme = "gruvbox",
	},
	sections = {
		lualine_a = {
			"mode",
			window,
		},
		lualine_c = {
			{
				"filename",
				path = 1,
			},
		},
	},
})
