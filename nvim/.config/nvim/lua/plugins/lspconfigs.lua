return {
	{
		"williamboman/mason.nvim",
		cond = function()
			return not vim.g.vscode
		end,
		config = function()
			require("mason").setup()
		end,
	},
	{
		"williamboman/mason-lspconfig.nvim",
		cond = function()
			return not vim.g.vscode
		end,
		config = function()
			require("mason-lspconfig").setup({
				ensure_installed = { "lua_ls", "ts_ls", "ruby_lsp", "rubocop", "cssls", "eslint", "csharp_ls" },
			})
			require("mason-lspconfig").setup_handlers({
				function(server_name)
					require("lspconfig")[server_name].setup({})
				end,
				-- server-specific handlers
				-- ["server-name'] = function()
				--   require("other-thing").setup {}
				-- end
			})
		end,
	},
	{
		"neovim/nvim-lspconfig",
		config = function()
			vim.keymap.set("n", "<leader>ca", vim.lsp.buf.code_action, { desc = "Code action" })
			vim.keymap.set("n", "<leader>cf", vim.lsp.buf.format, { desc = "LSP format" })
			vim.keymap.set("n", "<leader>cr", vim.lsp.buf.references, { desc = "Show references" })
			vim.keymap.set("n", "<leader>cd", vim.lsp.buf.definition, { desc = "Go to definition" })
			vim.keymap.set("n", "<leader>cD", vim.lsp.buf.declaration, { desc = "Go to declaration" })
		end,
	},
}
