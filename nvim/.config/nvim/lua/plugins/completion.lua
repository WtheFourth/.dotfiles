return {
	{
		"saghen/blink.cmp",
		event = "InsertEnter",
		version = "^1",
		config = function()
			require("blink.cmp").setup({
				keymap = {
				preset = "default",
				["<Up>"] = { "select_prev", "fallback" },
				["<Down>"] = { "select_next", "fallback" },
				["<Tab>"] = { "accept", "fallback" },
			},
				appearance = { nerd_font_variant = "mono" },
				completion = { documentation = { auto_show = true } },
				sources = { default = { "lsp", "path", "snippets", "buffer" } },
				fuzzy = { implementation = "prefer_rust_with_warning" },
			})
		end,
	},
}
