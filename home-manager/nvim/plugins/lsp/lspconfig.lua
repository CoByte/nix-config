local lspconfig = require("lspconfig")
local cmp_nvim_lsp = require("cmp_nvim_lsp")

-- local keymaps = require("cobyte.core.keymaps")

local on_attach = function(client, buffer)
  -- keymaps.on_lsp_attach(client, buffer)
end

-- used to enable autocompletion
local capabilities = cmp_nvim_lsp.default_capabilities()

local signs = { Error = " ", Warn = " ", Hint = "ﴞ ", Info = " " }
for type, icon in pairs(signs) do
  local hl = "DiagnosticSign" .. type
  vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = "" })
end

-- automatically handles lsp servers
-- this doesn't work bc lsps aren't installed by mason anymore
-- may need to do this manually or find another way :|
-- mason_lspconfig.setup_handlers({
-- 	function(server)
-- 		lspconfig[server].setup({
-- 			capabilities = capabilities,
-- 			on_attach = on_attach,
-- 		})
-- 	end,
-- })

local function configure_lsp(name, more_config)
  local working = {
    on_attach = on_attach,
    capabilities = capabilities,
  }
  for k, v in pairs(more_config) do working[k] = v end
  lspconfig[name].setup(working)
end

configure_lsp("nil_ls", {})

configure_lsp("rust_analyzer", {
  settings = {
    ["rust-analyzer"] = {
      checkOnSave = {
        command = "clippy",
        allTargets = false,
      }
    }
  }
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
  capabilities = capabilities,
  on_attach = on_attach,
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
lspconfig["clangd"].setup({
  capabilities = capabilities,
  on_attach = on_attach,
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

lspconfig["typst_lsp"].setup({
  on_attach = function(client, buffer)
    on_attach(client, buffer)
    -- keymaps.on_typst_attach()
  end,
  capabilities = capabilities,
  settings = {
    exportPdf = "never",
  },
})

lspconfig["ruby_lsp"].setup({
  capabilities = capabilities,
  on_attach = on_attach,
  init_options = {
    formatter = "standard",
    linters = { "standard" },
  },
})

lspconfig["racket_langserver"].setup({
  capabilities = capabilities,
  on_attach = on_attach,
})
