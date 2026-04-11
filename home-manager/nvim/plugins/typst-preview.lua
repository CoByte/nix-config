local typstprev = require("typst-preview")

typstprev.setup({
	debug = true,
	open_cmd = "firefox %s -P typst-preview --class typst-preview",
	dependencies_bin = {
		["tinymist"] = os.getenv("HOME") .. "/.nix-profile/bin/tinymist",
	},
})
