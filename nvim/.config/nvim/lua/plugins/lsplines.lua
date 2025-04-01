return {
	"https://git.sr.ht/~whynothugo/lsp_lines.nvim",
	cond = function()
		return not vim.g.vscode
	end,
	config = function()
		require("lsp_lines").setup()
		vim.diagnostic.config({ virtual_text = false })
	end,
}
