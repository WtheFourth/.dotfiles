return {
	{
		"williamboman/mason.nvim",
		config = function()
			require("mason").setup()
		end,
	},
	{
		"williamboman/mason-lspconfig.nvim",
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
			vim.keymap.set("n", "<leader>ca", vim.lsp.buf.code_action, { desc = "Code action" })
			vim.keymap.set("n", "<leader>cf", vim.lsp.buf.format, { desc = "LSP format" })
			vim.keymap.set("n", "<leader>cd", vim.lsp.buf.definition, { desc = "Go to definition" })
			vim.keymap.set("n", "<leader>cD", vim.lsp.buf.declaration, { desc = "Go to declaration" })
		end,
	},
	{
		"neovim/nvim-lspconfig",
	},
}
