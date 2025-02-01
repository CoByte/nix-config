local wk = require("which-key")
local luasnip = require("luasnip")

-- set leader key
vim.g.mapleader = " "
vim.g.maplocalleader = " "

local keymap = vim.keymap -- for conciseness

-- easy exit out of insert mode
keymap.set("i", "jk", "<ESC>")
keymap.set("i", "kj", "<ESC>")

-- ensures space doesn't do anything in normal mode on its own
keymap.set("n", "<Space>", "<Nop>", { silent = true, remap = false })

-- deleting a character will not add it to the clipboard
-- keymap.set('n', 'x', '_x', { silent = true, remap = false });

-- buffer cycling
keymap.set("n", "<S-h>", ":BufferLineCyclePrev<CR>")
keymap.set("n", "<S-l>", ":BufferLineCycleNext<CR>")

-- luasnip
keymap.set({ "i", "s" }, "<C-l>", function()
	if luasnip.expand_or_jumpable() then
		luasnip.expand_or_jump()
	end
end, { silent = true })

keymap.set({ "i", "s" }, "<C-h>", function()
	if luasnip.jumpable(-1) then
		luasnip.jump(-1)
	end
end, { silent = true })

-- top level binds
wk.add({
	{ "<leader>h", ":nohlsearch<CR>", desc = "Clear highlight" },
	{ "<leader>e", ":NvimTreeToggle<CR>", desc = "Toggle NvimTree" },
})

vim.api.nvim_create_user_command("ToggleCC", function(opts)
	local value = vim.api.nvim_get_option_value("colorcolumn", {})
	if value == "" then
		vim.opt.colorcolumn = "80"
	else
		vim.opt.colorcolumn = ""
	end
end, {})

-- random things
wk.add({
	{ "<leader>m", group = "misc" },
	{ "<leader>mc", "<cmd>ToggleCC<CR>" },
})

-- telescope
wk.add({
	{ "<leader>f", group = "telescope" },
	{ "<leader>fb", "<cmd>Telescope buffers<CR>", desc = "Buffers" },
	{ "<leader>fc", "<cmd>Telescope grep_string<CR>", desc = "Grep string" },
	{ "<leader>ff", "<cmd>Telescope find_files hidden=true no_ignore=true<CR>", desc = "Find files" },
	{ "<leader>fh", "<cmd>Telescope help_tags<CR>", desc = "Help" },
	{ "<leader>fs", "<cmd>Telescope live_grep<CR>", desc = "Live grep" },
})

-- REST
-- wk.add({
-- 	{ "<leader>r", group = "REST" },
-- 	{ "<leader>rl", "<Plug>RestNvimLast", desc = "Run prev. request" },
-- 	{ "<leader>rp", "<Plug>RestNvimPreview", desc = "Preview request" },
-- 	{ "<leader>rr", "<Plug>RestNvim", desc = "Run request" },
-- })

-- buffers
wk.add({
	{ "<leader>b", group = "buffer" },
	{ "<leader>bd", "<cmd>bp|bd #<CR>", desc = "Delete buffer" },
})

-- splits
wk.add({
	{ "<leader>s", group = "split" },
	{ "<leader>s-", "<C-w>s", desc = "Split vertically" },
	{ "<leader>s\\", "<C-w>v", desc = "Split horizontally" },
	{ "<leader>se", "<C-w>=", desc = "Equalize windows" },
	{ "<leader>sm", ":MaximizerToggle<CR>", desc = "Maximize Split" },
	{ "<leader>sx", ":close<CR>", desc = "Close current window" },
})

-- tests
wk.add({
	{ "<leader>t", group = "tests" },
	{ "<leader>tf", '<cmd>lua require("neotest").run.run(vim.fn.expand("%"))<CR>', desc = "Run file" },
	{ "<leader>tr", '<cmd>lua require("neotest").run.run()<CR>', desc = "Run nearest" },
	{ "<leader>tx", '<cmd>lua require("neotest").run.stop()<CR>', desc = "Stop nearest" },
})

-- hidden binds
wk.add({
	{ "v", hidden = true },
})
