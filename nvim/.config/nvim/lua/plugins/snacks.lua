return {
	{
		"folke/snacks.nvim",
		priority = 1000,
		lazy = false,
		keys = {
			-- Picker
			{
				"<C-p>",
				function()
					require("snacks").picker.files()
				end,
				desc = "Find files",
			},
			{
				"<leader>ff",
				function()
					require("snacks").picker.git_files()
				end,
				desc = "Find git files",
			},
			{
				"<leader>fg",
				function()
					require("snacks").picker.grep()
				end,
				desc = "Live grep",
			},
			{
				"<leader>fb",
				function()
					require("snacks").picker.buffers()
				end,
				desc = "Buffers",
			},
			{
				"<leader>fh",
				function()
					require("snacks").picker.help()
				end,
				desc = "Help tags",
			},
			{
				"<leader>fk",
				function()
					require("snacks").picker.keymaps()
				end,
				desc = "Keymaps",
			},
			{
				"<leader>fr",
				function()
					require("snacks").picker.recent()
				end,
				desc = "Recent files",
			},
			-- Lazygit
			{
				"<leader>gg",
				function()
					require("snacks").lazygit()
				end,
				desc = "Lazygit",
			},
			{
				"<leader>gf",
				function()
					require("snacks").lazygit.log_file()
				end,
				desc = "Lazygit file history",
			},
			{
				"<leader>gl",
				function()
					require("snacks").lazygit.log()
				end,
				desc = "Lazygit log",
			},
		},
		opts = {
			picker = {
				enabled = true,
				sources = {
					files = { hidden = true },
					grep = { hidden = true },
					recent = { filter = { cwd = true } },
				},
			},
			dashboard = {
				enabled = true,
				preset = {
					header = table.concat({
						"███╗   ██╗███████╗ ██████╗ ██╗   ██╗██╗███╗   ███╗",
						"████╗  ██║██╔════╝██╔═══██╗██║   ██║██║████╗ ████║",
						"██╔██╗ ██║█████╗  ██║   ██║██║   ██║██║██╔████╔██║",
						"██║╚██╗██║██╔══╝  ██║   ██║╚██╗ ██╔╝██║██║╚██╔╝██║",
						"██║ ╚████║███████╗╚██████╔╝ ╚████╔╝ ██║██║ ╚═╝ ██║",
						"╚═╝  ╚═══╝╚══════╝ ╚═════╝   ╚═══╝  ╚═╝╚═╝     ╚═╝",
						("                                           v%d.%d.%d"):format(
							vim.version().major,
							vim.version().minor,
							vim.version().patch
						),
					}, "\n"),
					keys = {
						{
							icon = " ",
							key = "f",
							desc = "Find file",
							action = function()
								require("snacks").picker.files()
							end,
						},
						{
							icon = " ",
							key = "r",
							desc = "Recent files",
							action = function()
								require("snacks").picker.recent()
							end,
						},
						{
							icon = " ",
							key = "g",
							desc = "Live grep",
							action = function()
								require("snacks").picker.grep()
							end,
						},
						{ icon = " ", key = "e", desc = "File browser", action = ":Oil" },
						{ icon = " ", key = "q", desc = "Quit", action = ":qa" },
					},
				},
			},
			lazygit = { enabled = true },
			notifier = { enabled = true },
			indent = { enabled = true },
			words = { enabled = true },
			quickfile = { enabled = true },
			bigfile = { enabled = true },
		},
	},
}
