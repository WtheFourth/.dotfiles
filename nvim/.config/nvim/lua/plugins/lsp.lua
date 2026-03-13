local lsps_to_enable = { "lua_ls", "vtsls", "eslint", "ruby_lsp", "cssls" }

return {
	{ "neovim/nvim-lspconfig" },
	{
		"williamboman/mason.nvim",
		opts = {
			registries = {
				"github:mason-org/mason-registry",
				"github:Crashdummyy/mason-registry",
			},
		},
	},
	{
		"williamboman/mason-lspconfig.nvim",
		dependencies = { "williamboman/mason.nvim", "neovim/nvim-lspconfig" },
		config = function()
			require("mason-lspconfig").setup({ ensure_installed = lsps_to_enable })
			vim.lsp.enable(lsps_to_enable)
		end,
	},
	{
		"WhoIsSethDaniel/mason-tool-installer.nvim",
		dependencies = { "williamboman/mason.nvim" },
		config = function()
			require("mason-tool-installer").setup({
				ensure_installed = { "prettierd", "prettier", "rubocop", "stylua", "netcoredbg" },
			})
		end,
	},
	{
		"seblyng/roslyn.nvim",
		opts = {},
	},
}
