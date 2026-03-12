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
			-- vim.cmd.colorscheme("tokyonight")
		end,
	},
	{
		"catppuccin/nvim",
		name = "catppuccin",
		priority = 1000,
		config = function()
			require("catppuccin").setup({
				integrations = {
					blink_cmp = {
						style = "bordered",
					},
					diffview = true,
					flash = true,
					mason = true,
					snacks = {
						enabled = true,
					},
					which_key = true,
				},
				custom_highlights = function(colors)
					return {
						CursorLineNr = { fg = colors.flamingo },
					}
				end,
			})
			vim.cmd.colorscheme("catppuccin-mocha")
		end,
	},
}
