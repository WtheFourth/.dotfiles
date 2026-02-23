return {
	"stevearc/conform.nvim",
	cond = function()
		return not vim.g.vscode
	end,
	opts = {},
	config = function()
		require("conform").setup({
			formatters_by_ft = {
				csharp = { "csharpier" },
				javascript = { "prettierd", "prettier", stop_after_first = true },
				lua = { "stylua" },
				-- Conform will run multiple formatters sequentially
				--python = { "isort", "black" },
				-- You can customize some of the format options for the filetype (:help conform.format)
				--rust = { "rustfmt", lsp_format = "fallback" },
			},
			format_on_save = {
				-- These options will be passed to conform.format()
				timeout_ms = 500,
				lsp_format = "fallback",
			},
		})
	end,
}
