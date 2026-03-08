return {
	{
		"sindrets/diffview.nvim",
		cmd = { "DiffviewOpen", "DiffviewClose", "DiffviewFileHistory" },
		keys = {
			{ "<leader>gd", "<cmd>DiffviewOpen<cr>", desc = "Diffview open" },
			{ "<leader>gh", "<cmd>DiffviewFileHistory %<cr>", desc = "Diffview file history" },
			{ "<leader>gH", "<cmd>DiffviewFileHistory<cr>", desc = "Diffview branch history" },
			{ "<leader>gq", "<cmd>DiffviewClose<cr>", desc = "Diffview close" },
		},
	},
	{
		"github/copilot.vim",
		event = "InsertEnter",
	},
}
