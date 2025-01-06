local lspconfig = require("lspconfig")
local cmp_nvim_lsp = require("cmp_nvim_lsp")
local wk = require("which-key")

local on_attach = function(client, buffer)
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

	vim.keymap.set("n", "[d", vim.diagnostic.goto_prev)
	vim.keymap.set("n", "]d", vim.diagnostic.goto_next)
	vim.keymap.set("n", "K", vim.lsp.buf.hover)
end

-- used to enable autocompletion
local capabilities = cmp_nvim_lsp.default_capabilities()

local signs = { Error = " ", Warn = " ", Hint = "ﴞ ", Info = " " }
for type, icon in pairs(signs) do
	local hl = "DiagnosticSign" .. type
	vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = "" })
end

-- helper for configuring lsp servers
local function configure_lsp(name, more_config)
	local working = {
		on_attach = on_attach,
		capabilities = capabilities,
	}
	for k, v in pairs(more_config) do
		working[k] = v
	end
	lspconfig[name].setup(working)
end

configure_lsp("nil_ls", {})

configure_lsp("rust_analyzer", {
	settings = {
		["rust-analyzer"] = {
			checkOnSave = {
				command = "clippy",
				allTargets = false,
			},
		},
	},
})

-- TODO: if you want this again you need to wire it up w/ nix
-- local path_to_elixirls = vim.fn.expand("~/.cache/nvim/lsp/elixir-ls/release/language_server.sh")
-- See [[https://www.mitchellhanberg.com/how-to-set-up-neovim-for-elixir-development/]] for details
-- lspconfig["elixirls"].setup({
-- 	cmd = { path_to_elixirls },
-- 	capabilities = capabilities,
-- 	on_attach = on_attach,
-- 	settings = {
-- 		elixirLS = {
-- 			dialyzerEnabled = false,
-- 			-- Disable auto-fetching deps
-- 			-- Apparently it's weird and buggy
-- 			fetchDeps = false,
-- 		},
-- 	},
-- })

configure_lsp("lua_ls", {
	settings = {
		Lua = {
			diagnostics = {
				globals = { "vim" },
			},
			workspace = {
				library = {
					[vim.fn.expand("$VIMRUNTIME/lua")] = true,
					[vim.fn.stdpath("config") .. "/lua"] = true,
				},
			},
		},
	},
})

-- TODO: I don't think I ever fixed this
configure_lsp("clangd", {
	cmd = {
		"clangd",
		"--background-index",
		"-j=12",
		"--query-driver=/usr/bin/**/clang-*,/bin/clang,/bin/clang++,/usr/bin/gcc,/usr/bin/g++",
		"--clang-tidy",
		"--clang-tidy-checks=*",
		"--all-scopes-completion",
		"--cross-file-rename",
		"--completion-style=detailed",
		"--header-insertion-decorators",
		"--header-insertion=iwyu",
		"--pch-storage=memory",
	},
})

configure_lsp("typst_lsp", {
	on_attach = function(client, buffer)
		on_attach(client, buffer)
		wk.add({
			{ "<leader>p", group = "Typst Preview" },
			{ "<leader>pp", "<cmd>TypstPreviewToggle<CR>", desc = "Toggle preview" },
			{ "<leader>pc", "<cmd>TypstPreviewFollowCursorToggle<CR>", desc = "Toggle cursor follow" },
			{ "<leader>pj", "<cmd>TypstPreviewSyncCursor<CR>", desc = "Sync cursor" },
		})
	end,
	settings = {
		exportPdf = "never",
	},
})

configure_lsp("ruby_lsp", {
	init_options = {
		formatter = "standard",
		linters = { "standard" },
	},
})

-- if you ever need this again i will be blown away
-- lspconfig["racket_langserver"].setup({
-- 	capabilities = capabilities,
-- 	on_attach = on_attach,
-- })
