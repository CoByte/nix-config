local cmp = require("cmp")
local luasnip = require("luasnip")
local lspkind = require("lspkind")
local wk = require("which-key")

require("luasnip/loaders/from_vscode").lazy_load()

vim.opt.completeopt = "menu,menuone,noselect"

-- autocompletion

cmp.setup({
	snippet = {
		expand = function(args)
			luasnip.lsp_expand(args.body)
		end,
	},
	mapping = {
		["<S-k>"] = cmp.mapping.select_prev_item(),
		["<S-j>"] = cmp.mapping.select_next_item(),
		["<S-b>"] = cmp.mapping.scroll_docs(-4),
		["<S-f>"] = cmp.mapping.scroll_docs(4),
		["<S-Space>"] = cmp.mapping.complete(),
		["<S-e>"] = cmp.mapping.abort(),
		["<CR>"] = cmp.mapping.confirm({ select = false }),
	},
	sources = cmp.config.sources({
		{ name = "nvim_lsp" },
		{ name = "luasnip" },
		{ name = "buffer" },
		{ name = "path" },
	}),
	formatting = {
		format = lspkind.cmp_format({
			maxwidth = 50,
			ellipsis_char = "...",
		}),
	},
})
