vim.g.mapleader = " "
vim.o.number = true
vim.o.relativenumber = true
vim.o.signcolumn = "yes"
vim.o.tabstop = 4
vim.o.cursorline = true
vim.o.termguicolors = true

vim.keymap.set("n", "<leader>o", ":update<CR> :source<CR>", { desc = "Update & source" })
vim.keymap.set("n", "<leader>ccl", "gcc", { desc = "Comment line", remap = true })
vim.keymap.set("v", "c", "gc", { desc = "Comment", remap = true })

vim.pack.add({
	{ src = "https://github.com/folke/tokyonight.nvim" },
	{ src = "https://github.com/folke/which-key.nvim" },
	{ src = "https://github.com/neovim/nvim-lspconfig" },
	{ src = "https://github.com/nvim-mini/mini.icons" },
	{ src = "https://github.com/stevearc/conform.nvim" },
	{ src = "https://github.com/williamboman/mason.nvim" },
	{ src = "https://github.com/williamboman/mason-lspconfig.nvim" },
})

require "which-key".add({
	{ "<leader>c",  group = "Code" },
	{ "<leader>cc", group = "Comment" },
})

vim.filetype.add({
	filename = {
		Brewfile = "ruby",
		[".Brewfile"] = "ruby",
	}
})

local lsps_to_enable = { "lua_ls", "ts_ls", "eslint", "ruby_lsp" }

require("mason").setup()
require("mason-lspconfig").setup({ ensure_installed = lsps_to_enable })
vim.lsp.enable(lsps_to_enable)
require("conform").setup({
	formatters_by_ft = {
		ruby = { "rubocop" },
	},
})

vim.keymap.set({ "n", "v", "x" }, "<leader>cf", function()
	require("conform").format({ async = true, lsp_fallback = true })
end, { desc = "Format" })

require "tokyonight".setup(
	{
		on_highlights = function(highlights, colors)
			highlights.CursorLineNr = { fg = colors.yellow }
		end
	}
)
vim.cmd.colorscheme("tokyonight")

vim.api.nvim_create_user_command("PackClean", function()
	vim.pack.del(vim.iter(vim.pack.get())
		:filter(function(x) return not x.active end)
		:map(function(x) return x.spec.name end)
		:totable())
end, {})
