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
}
