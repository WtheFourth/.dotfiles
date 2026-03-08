return {
	{
		"folke/snacks.nvim",
		priority = 1000,
		lazy = false,
		keys = {
			{ "<leader>gg", function() require("snacks").lazygit() end, desc = "Lazygit" },
			{ "<leader>gf", function() require("snacks").lazygit.log_file() end, desc = "Lazygit file history" },
			{ "<leader>gl", function() require("snacks").lazygit.log() end, desc = "Lazygit log" },
		},
		opts = {
			lazygit = { enabled = true },
			notifier = { enabled = true },
			indent = { enabled = true },
			words = { enabled = true },
			quickfile = { enabled = true },
			bigfile = { enabled = true },
		},
	},
}
