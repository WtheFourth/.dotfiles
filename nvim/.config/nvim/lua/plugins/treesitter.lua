return {
	{
		"nvim-treesitter/nvim-treesitter",
		lazy = false,
		build = ":TSUpdate",
		config = function()
			vim.opt.rtp:prepend(vim.fn.stdpath("data") .. "/lazy/nvim-treesitter/runtime")
		end,
	},
}
