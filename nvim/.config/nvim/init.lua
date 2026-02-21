vim.g.mapleader = " "
vim.o.number = true
vim.o.relativenumber = true
vim.o.signcolumn = "yes"
vim.o.tabstop = 4

vim.keymap.set("n", "<leader>o", ":update<CR> :source<CR>", { desc = "Update & source" })

vim.pack.add({
	{ src = "https://github.com/folke/tokyonight.nvim" },
	{ src = "https://github.com/folke/which-key.nvim" },
	{ src = "https://github.com/neovim/nvim-lspconfig" },
	{ src = "https://github.com/nvim-mini/mini.icons" },
	{ src = "https://github.com/nvim-mini/mini.comment" },
})

require "which-key".add({
	{ "<leader>c",  group = "Code" },
	{ "<leader>cc", group = "Comment" },
})

require "mini.comment".setup({
	mappings = {
		comment = "<leader>ccc",
		comment_line = "<leader>ccl",
		comment_visual = "c",
	}
})


vim.lsp.enable({ "lua_ls" })
vim.keymap.set({ "n", "v", "x" }, "<leader>cf", vim.lsp.buf.format, { desc = "Format" })

vim.cmd.colorscheme("tokyonight")
vim.o.cursorline = true
require "tokyonight".setup(
	{
		on_highlights = function(highlights, colors)
			highlights.CursorLineNr = { fg = colors.yellow }
		end
	}
)
