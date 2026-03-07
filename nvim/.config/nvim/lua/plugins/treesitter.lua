return {
	{
		"nvim-treesitter/nvim-treesitter",
		config = function()
			vim.api.nvim_create_user_command("TSInstallAll", function()
				require("nvim-treesitter").install({
					"lua",
					"vim",
					"vimdoc",
					"typescript",
					"javascript",
					"tsx",
					"html",
					"css",
					"ruby",
					"json",
					"yaml",
					"markdown",
					"c_sharp",
				})
			end, {})
		end,
	},
}
