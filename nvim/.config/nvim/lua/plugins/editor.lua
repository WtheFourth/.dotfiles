return {
	{
		"folke/which-key.nvim",
		event = "VeryLazy",
		keys = {
			{
				"<leader>?",
				function()
					require("which-key").show({ global = true })
				end,
				desc = "Which key?",
			},
		},
		config = function()
			require("which-key").add({
				{ "<leader>c", group = "Code" },
				{ "<leader>cc", group = "Comment" },
				{ "<leader>f", group = "Find" },
				{ "<leader>d", group = "Debug" },
				{ "<leader>g", group = "Git" },
				{ "<leader>x", group = "Diagnostics" },
				{ "<leader>t", group = "Test" },
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
							:map(function(c)
								return c.name
							end)
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
	{
		"nvim-mini/mini.icons",
		config = function()
			require("mini.icons").setup()
			require("mini.icons").mock_nvim_web_devicons()
		end,
	},
	{
		"folke/flash.nvim",
		event = "VeryLazy",
		opts = {
			modes = {
				search = { enabled = true },
				char = { enabled = false },
			},
		},
		keys = {
			{
				"s",
				function()
					require("flash").jump()
				end,
				mode = { "n", "x", "o" },
				desc = "Flash jump",
			},
			{
				"S",
				function()
					require("flash").treesitter()
				end,
				mode = { "n", "x", "o" },
				desc = "Flash treesitter",
			},
			{
				"r",
				function()
					require("flash").remote()
				end,
				mode = "o",
				desc = "Flash remote",
			},
			{
				"R",
				function()
					require("flash").treesitter_search()
				end,
				mode = { "o", "x" },
				desc = "Flash treesitter search",
			},
			{
				"<C-s>",
				function()
					require("flash").toggle()
				end,
				mode = "c",
				desc = "Flash toggle search",
			},
		},
	},
	{
		"folke/trouble.nvim",
		opts = {
			modes = {
				preview_right = {
					mode = "diagnostics",
					filter = { severity = vim.diagnostic.severity.ERROR },
					preview = {
						type = "split",
						relative = "win",
						position = "right",
						size = 0.5,
					},
				},
			},
		},
		cmd = "Trouble",
		keys = {
			{
				"<leader>xx",
				"<cmd>Trouble preview_right toggle<cr>",
				desc = "Diagnostics (Trouble)",
			},
			{
				"<leader>xX",
				"<cmd>Trouble preview_right toggle filter.buf=0<cr>",
				desc = "Buffer Diagnostics (Trouble)",
			},
			{
				"<leader>cs",
				"<cmd>Trouble symbols toggle focus=false<cr>",
				desc = "Symbols (Trouble)",
			},
			{
				"<leader>cl",
				"<cmd>Trouble lsp toggle focus=false win.position=right<cr>",
				desc = "LSP Definitions / references / ... (Trouble)",
			},
			{
				"<leader>xL",
				"<cmd>Trouble loclist toggle<cr>",
				desc = "Location List (Trouble)",
			},
			{
				"<leader>xQ",
				"<cmd>Trouble qflist toggle<cr>",
				desc = "Quickfix List (Trouble)",
			},
		},
	},
	{
		"echasnovski/mini.ai",
		event = "VeryLazy",
		opts = {
			n_lines = 500,
		},
	},
	{
		-- gz prefix avoids conflict with flash's s mapping in n/x/o modes
		-- gza{motion}{char} = add, gzd{char} = delete, gzr{old}{new} = replace
		"echasnovski/mini.surround",
		event = "VeryLazy",
		opts = {
			mappings = {
				add = "gza",
				delete = "gzd",
				find = "gzf",
				find_left = "gzF",
				highlight = "gzh",
				replace = "gzr",
				update_n_lines = "gzn",
			},
		},
	},
	{
		"echasnovski/mini.pairs",
		event = "InsertEnter",
		opts = {},
	},
}
