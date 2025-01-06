local wk = require("which-key")
-- local luasnip = require("luasnip")

-- set leader key
vim.g.mapleader = " "
vim.g.maplocalleader = " "

local keymap = vim.keymap -- for conciseness

-- The output of the module
-- To make the config easier to navigate, all keybind configuration should occur
-- in this file. If keybinds must be set by another module (for example, on lsp
-- attach), they should be placed in output, and loaded with require.
local output = {}

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
-- keymap.set({ "i", "s" }, "<C-l>", function()
-- 	if luasnip.expand_or_jumpable() then
-- 		luasnip.expand_or_jump()
-- 	end
-- end, { silent = true })
--
-- keymap.set({ "i", "s" }, "<C-h>", function()
-- 	if luasnip.jumpable(-1) then
-- 		luasnip.jump(-1)
-- 	end
-- end, { silent = true })

-- top level binds
wk.add({
	{ "<leader>h", ":nohlsearch<CR>", desc = "Clear highlight" },
	{ "<leader>e", ":NvimTreeToggle<CR>", desc = "Toggle NvimTree" },
})

-- telescope
wk.add({
	{ "<leader>f", group = "telescope" },
	{ "<leader>fb", "<cmd>Telescope buffers<CR>", desc = "Buffers" },
	{ "<leader>fc", "<cmd>Telescope grep_string<CR>", desc = "Grep string" },
	{ "<leader>ff", "<cmd>Telescope find_files<CR>", desc = "Find files" },
	{ "<leader>fh", "<cmd>Telescope help_tags<CR>", desc = "Help" },
	{ "<leader>fs", "<cmd>Telescope live_grep<CR>", desc = "Live grep" },
})

-- REST
wk.add({
	{ "<leader>r", group = "REST" },
	{ "<leader>rl", "<Plug>RestNvimLast", desc = "Run prev. request" },
	{ "<leader>rp", "<Plug>RestNvimPreview", desc = "Preview request" },
	{ "<leader>rr", "<Plug>RestNvim", desc = "Run request" },
})

-- splits
wk.add({
	{ "<leader>s", group = "split" },
	{ "<leader>s-", "<C-w>s", desc = "Split vertically" },
	{ "<leader>se", "<C-w>=", desc = "Equalize windows" },
	{ "<leader>sm", ":MaximizerToggle<CR>", desc = "Maximize Split" },
	{ "<leader>sx", ":close<CR>", desc = "Close current window" },
	{ "<leader>s|", "<C-w>v", desc = "Split horizontally" },
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

-- Sets up LSP keybinds
function output.on_lsp_attach(client, buffer)
	-- top level binds
	wk.add({
		{ "<leader>D", "<cmd>Telescope diagnostics bufnr=0<CR>", desc = "Diagnose file" },
		{ "<leader>d", vim.diagnostic.open_float, desc = "Diagnose line" },
	})

	-- LSP
	wk.add({
		{ "<leader>l", group = "LSP" },
		{ "<leader>lR", "<cmd>Telescope lsp_references<CR>", desc = "References" },
		{ "<leader>la", vim.lsp.buf.code_action, desc = "Code action" },
		{ "<leader>lD", vim.lsp.buf.declaration, desc = "Declaration" },
		{ "<leader>ld", "<cmd>Telescope lsp_definitions<CR>", desc = "Definition" },
		{ "<leader>lh", vim.lsp.buf.hover, desc = "Hover" },
		{ "<leader>li", "<cmd>Telescope lsp_inplementations<CR>", desc = "Implementations" },
		{ "<leader>lr", ":IncRename ", desc = "Smart rename" },
		{ "<leader>ls", vim.lsp.buf.signature_help, desc = "Signature info" },
		{ "<leader>lt", "<cmd>Telescope lsp_type_definitions<CR>", desc = "Type definition" },
	})

	keymap.set("n", "[d", vim.diagnostic.goto_prev)
	keymap.set("n", "]d", vim.diagnostic.goto_next)
	keymap.set("n", "K", vim.lsp.buf.hover)
end

-- Sets up Typst-specific keybinds (only when a typst file is open)
function output.on_typst_attach(client, buffer)
	wk.add({
		{ "<leader>p", group = "Typst Preview" },
		{ "<leader>pp", "<cmd>TypstPreviewToggle<CR>", desc = "Toggle preview" },
		{ "<leader>pc", "<cmd>TypstPreviewFollowCursorToggle<CR>", desc = "Toggle cursor follow" },
		{ "<leader>pj", "<cmd>TypstPreviewSyncCursor<CR>", desc = "Sync cursor" },
	})
end

-- Returns and configures autocompletion keybinds
-- `cmp` is the nvim-cmp package
function output.cmp(cmp)
	return cmp.mapping.preset.insert({
		["<C-k>"] = cmp.mapping.select_prev_item(),
		["<C-j>"] = cmp.mapping.select_next_item(),
		["<C-b>"] = cmp.mapping.scroll_docs(-4),
		["<C-f>"] = cmp.mapping.scroll_docs(4),
		["<C-Space>"] = cmp.mapping.complete(),
		["<C-e>"] = cmp.mapping.abort(),
		["<CR>"] = cmp.mapping.confirm({ select = false }),
	})
end

-- Returns telescope keybinds
-- actions is telescope.actions
function output.telescope(actions)
	return {
		i = {
			["<C-k>"] = actions.move_selection_previous,
			["<C-j>"] = actions.move_selection_next,
			["<C-q>"] = actions.send_selected_to_qflist + actions.open_qflist,
		},
	}
end

-- return output
