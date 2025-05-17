local conform = require("conform")

conform.setup({
	formatters_by_ft = {
		lua = { "stylua" },
		rust = { "rustfmt" },
		zig = { "zigfmt" },
		c = { "clang-format" },
		["c++"] = { "clang-format" },
		nix = { "alejandra" },
		python = { "black" },
	},

	format_on_save = {
		timeout_ms = 500,
		lsp_format = "never",
	},
})
