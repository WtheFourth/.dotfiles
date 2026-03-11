return {
	{
		"folke/tokyonight.nvim",
		lazy = false,
		priority = 1000,
		config = function()
			require("tokyonight").setup({
				on_highlights = function(highlights, colors)
					highlights.CursorLineNr = { fg = colors.yellow }
				end,
			})
			vim.cmd.colorscheme("tokyonight")
		end,
	},
}
