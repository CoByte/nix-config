local telescope = require("telescope")
local actions = require("telescope.actions")
local themes = require("telescope.themes")

-- local mappings = require("cobyte.core.keymaps").telescope

telescope.setup({
	defaults = {
		-- mappings = mappings(actions),
	},
	extensions = {
		fzf = {
			fuzzy = true,
			override_generic_sorter = true,
			case_mode = "smart_case",
		},
		["ui-select"] = {
			themes.get_dropdown({}),
		},
	},
})

telescope.load_extension("fzf")
telescope.load_extension("ui-select")
