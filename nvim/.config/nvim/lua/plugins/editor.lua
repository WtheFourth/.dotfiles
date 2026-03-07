return {
	{
		"stevearc/oil.nvim",
		keys = {
			{ "-", "<cmd>Oil<cr>", desc = "Open file explorer" },
		},
		config = function()
			require("oil").setup()
		end,
	},
	{
		"ibhagwan/fzf-lua",
		keys = {
			{ "<C-p>", "<cmd>FzfLua files<cr>", desc = "Find files" },
			{ "<leader>ff", "<cmd>FzfLua git_files<cr>", desc = "Find git files" },
			{ "<leader>fg", "<cmd>FzfLua live_grep<cr>", desc = "Live grep" },
			{ "<leader>fb", "<cmd>FzfLua buffers<cr>", desc = "Buffers" },
			{ "<leader>fh", "<cmd>FzfLua helptags<cr>", desc = "Help tags" },
			{ "<leader>fk", "<cmd>FzfLua keymaps<cr>", desc = "Keymaps" },
			{ "<leader>fr", "<cmd>FzfLua oldfiles<cr>", desc = "Recent files" },
		},
		config = function()
			require("fzf-lua").setup({})
		end,
	},
	{
		"folke/which-key.nvim",
		event = "VeryLazy",
		config = function()
			require("which-key").add({
				{ "<leader>c", group = "Code" },
				{ "<leader>cc", group = "Comment" },
				{ "<leader>f", group = "Find" },
				{ "<leader>d", group = "Debug" },
				{ "<leader>g", group = "Git" },
			})
		end,
	},
	{
		"echasnovski/mini.starter",
		config = function()
			local starter = require("mini.starter")
			starter.setup({
				header = table.concat({
					"███╗   ██╗███████╗ ██████╗ ██╗   ██╗██╗███╗   ███╗",
					"████╗  ██║██╔════╝██╔═══██╗██║   ██║██║████╗ ████║",
					"██╔██╗ ██║█████╗  ██║   ██║██║   ██║██║██╔████╔██║",
					"██║╚██╗██║██╔══╝  ██║   ██║╚██╗ ██╔╝██║██║╚██╔╝██║",
					"██║ ╚████║███████╗╚██████╔╝ ╚████╔╝ ██║██║ ╚═╝ ██║",
					"╚═╝  ╚═══╝╚══════╝ ╚═════╝   ╚═══╝  ╚═╝╚═╝     ╚═╝",
					"                                           NIGHTLY",
				}, "\n"),
				items = {
					{ name = "Find file", action = "FzfLua files", section = "Actions" },
					{ name = "Recent files", action = "FzfLua oldfiles", section = "Actions" },
					{ name = "Live grep", action = "FzfLua live_grep", section = "Actions" },
					{ name = "File browser", action = "Oil", section = "Actions" },
					{ name = "Quit", action = "qa", section = "Actions" },
				},
				footer = "",
			})
		end,
	},
	{
		"echasnovski/mini.statusline",
		config = function()
			local statusline = require("mini.statusline")
			statusline.setup({
				content = {
					active = function()
						local mode, mode_hl = statusline.section_mode({ trunc_width = 120 })
						mode = "\u{e7c5} " .. mode:upper()
						local git = statusline.section_git({ trunc_width = 40, icon = "\u{e0a0}" })
						local diff = statusline.section_diff({ trunc_width = 75, icon = "\u{f440}" })
						local diagnostics = statusline.section_diagnostics({
							trunc_width = 75,
							signs = { ERROR = "\u{f659} ", WARN = "\u{f529} ", INFO = "\u{f7fc} ", HINT = "\u{f0335} " },
						})
						local filename = statusline.section_filename({ trunc_width = 140 })
						local fileinfo = statusline.section_fileinfo({ trunc_width = 120 })
						local location = statusline.section_location({ trunc_width = 75 })
						local search = statusline.section_searchcount({ trunc_width = 75 })

						local lsp_names = vim.iter(vim.lsp.get_clients({ bufnr = 0 }))
							:map(function(c) return c.name end)
							:totable()
						local lsp = #lsp_names > 0 and "\u{f085} " .. table.concat(lsp_names, ", ") or ""

						return statusline.combine_groups({
							{ hl = mode_hl, strings = { mode } },
							{ hl = "MiniStatuslineDevinfo", strings = { git, diff, diagnostics } },
							"%<",
							{ hl = "MiniStatuslineFilename", strings = { filename } },
							"%=",
							{ hl = "MiniStatuslineDevinfo", strings = { lsp } },
							{ hl = "MiniStatuslineFileinfo", strings = { fileinfo } },
							{ hl = mode_hl, strings = { search, location } },
						})
					end,
				},
			})
		end,
	},
	{ "nvim-mini/mini.icons", opts = {} },
}
