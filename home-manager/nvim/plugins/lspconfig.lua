local lspconfig = require("lspconfig")
local cmp_nvim_lsp = require("cmp_nvim_lsp")
local wk = require("which-key")

local on_attach = function(client, buffer)
	-- this is probably in scope by now...
	local pickers = _G["MiniExtra"].pickers

	local function pick_lsp(scope)
		return function()
			pickers.lsp({ scope = scope })
		end
	end

	wk.add({
		{ "<leader>D", pickers.diagnostic, desc = "Diagnose file", buffer = buffer },
		{ "<leader>d", vim.diagnostic.open_float, desc = "Diagnose line", buffer = buffer },
	})

	-- jumps
	wk.add({
		{ "<leader>jd", vim.lsp.buf.definition, desc = "Definition", buffer = buffer },
		{ "<leader>jD", vim.lsp.buf.declaration, desc = "Declaration", buffer = buffer },
	})

	-- lists
	wk.add({
		{ "<leader>lr", pick_lsp("references"), desc = "References", buffer = buffer },
		{ "<leader>li", pick_lsp("implementation"), desc = "Implementations", buffer = buffer },
	})

	-- track cmd line and run `:wa` after an IncRename
	do
		local last_cmd = ""

		vim.api.nvim_create_autocmd("CmdlineChanged", {
			pattern = ":",
			callback = function()
				last_cmd = vim.fn.getcmdline()
			end,
		})

		vim.api.nvim_create_autocmd("CmdlineLeave", {
			pattern = ":",
			callback = function()
				if last_cmd:match("^IncRename") then
					vim.schedule(function()
						vim.cmd("wa")
					end)
				end
			end,
		})
	end

	-- actions
	wk.add({
		{ "<leader>aa", vim.lsp.buf.code_action, desc = "Code action", buffer = buffer },
		{ "<leader>ah", vim.lsp.buf.hover, desc = "Hover", buffer = buffer },
		{ "<leader>ar", ":IncRename ", desc = "Rename", buffer = buffer },
		{ "<leader>as", vim.lsp.buf.signature_help, desc = "Signature info", buffer = buffer },
		{ "<leader>at", vim.lsp.buf.type_definition, desc = "Type definition", buffer = buffer },
	})

	vim.keymap.set("n", "[d", vim.diagnostic.goto_prev)
	vim.keymap.set("n", "]d", vim.diagnostic.goto_next)
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
configure_lsp("arduino_language_server", {})
configure_lsp("zls", {})
configure_lsp("ocamllsp", {})

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
		"--query-driver=/usr/bin/**/clang-*,/bin/clang,/bin/clang++,/usr/bin/gcc,/usr/bin/g++,/home/raine/.arduino15/packages/*/tools/**/*-gcc,/home/raine/.arduino15/packages/*/tools/**/*-g++",
		"--clang-tidy",
		"--clang-tidy-checks=*",
		"--all-scopes-completion",
		"--cross-file-rename",
		"--completion-style=detailed",
		"--header-insertion-decorators",
		"--header-insertion=iwyu",
		"--pch-storage=memory",
	},
	init_options = {
		fallbackFlags = { "-std=c++17" },
	},
})

configure_lsp("tinymist", {
	on_attach = function(client, buffer)
		on_attach(client, buffer)
		wk.add({
			{ "<leader>p", group = "Typst Preview", buffer = buffer },
			{ "<leader>pp", "<cmd>TypstPreviewToggle<CR>", desc = "Toggle preview", buffer = buffer },
			{ "<leader>pc", "<cmd>TypstPreviewFollowCursorToggle<CR>", desc = "Toggle cursor follow", buffer = buffer },
			{ "<leader>pj", "<cmd>TypstPreviewSyncCursor<CR>", desc = "Sync cursor", buffer = buffer },
		})
	end,
	root_dir = lspconfig.util.root_pattern("main.typ", "*.typ"),
	settings = {
		tinymist = {
			settings = {
				formatterMode = "typstfmt",
			},
		},
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
