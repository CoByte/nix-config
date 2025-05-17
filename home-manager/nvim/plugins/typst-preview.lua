local typstprev = require("typst-preview")

typstprev.setup({
	dependencies_bin = {
		["tinymist"] = os.getenv("HOME") .. "/.nix-profile/bin/tinymist",
	},
})
