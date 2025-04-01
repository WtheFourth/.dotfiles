return {
	"echasnovski/mini.nvim",
	cond = function()
		return not vim.g.vscode
	end,
	version = "*",
}
