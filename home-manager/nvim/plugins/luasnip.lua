local luasnip = require("luasnip")
local types = require("luasnip.util.types")

luasnip.config.set_config({
	-- remember last snippet
	history = true,

	-- dynamically update snippet text
	updateevents = "TextChanged,TextChangedI",

	-- autosnippets
})
