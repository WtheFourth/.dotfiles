return {
	"nvim-telescope/telescope.nvim",
	tag = "0.1.8",
	cond = function()
		return not vim.g.vscode
	end,
	dependencies = {
		"nvim-lua/plenary.nvim",
		{ -- If encountering errors, see telescope-fzf-native README for installation instructions
			"nvim-telescope/telescope-fzf-native.nvim",

			-- `build` is used to run some command when the plugin is installed/updated.
			-- This is only run then, not every time Neovim starts up.
			build = "make",

			-- `cond` is a condition used to determine whether this plugin should be
			-- installed and loaded.
			cond = function()
				return vim.fn.executable("make") == 1
			end,
		},
		{ "nvim-telescope/telescope-ui-select.nvim" },

		-- Useful for getting pretty icons, but requires a Nerd Font.
		{ "nvim-tree/nvim-web-devicons", enabled = vim.g.have_nerd_font },
	},
	config = function()
		local telescope = require("telescope")
		telescope.setup({
			defaults = {
				file_ignore_patterns = { "^.git/" },
			},
			extensions = {
				["ui-select"] = {
					require("telescope.themes").get_dropdown(),
				},
				fzf = {
					fuzzy = true,
					override_generic_sorter = true,
					override_file_sorter = true,
					case_mode = "ignore_case",
				},
			},
			pickers = {
				find_files = {
					find_command = vim.fn.executable("fd") == 1
							and { "fd", "--type", "f", "--hidden", "--exclude", ".git" }
						or vim.fn.executable("fdfind") == 1
								and { "fdfind", "--type", "f", "--hidden", "--exclude", ".git" }
						or nil,
					hidden = true,
				},
				live_grep = {
					file_ignore_patterns = { "node_modules", ".git", ".venv" },
					additional_args = function(_)
						return { "--hidden" }
					end,
				},
			},
		})

		local builtin = require("telescope.builtin")

		local function smart_find_files()
			local ok = pcall(builtin.git_files)
			if not ok then
				builtin.find_files()
			end
		end
		_G.TelescopeSmartFindFiles = smart_find_files

		vim.keymap.set("n", "<C-p>", smart_find_files, { desc = "Telescope find files" })
		vim.keymap.set("n", "<leader>fg", builtin.live_grep, { desc = "Telescope live grep" })
		vim.keymap.set("n", "<leader>fb", builtin.buffers, { desc = "Telescope buffers" })
		vim.keymap.set("n", "<leader>fh", builtin.help_tags, { desc = "Telescope help tags" })
		vim.keymap.set("n", "<leader>ft", builtin.treesitter, { desc = "Telescope treesitter" })
		vim.keymap.set("n", "<leader>fk", builtin.keymaps, { desc = "Telescope keymaps" })
		vim.keymap.set("n", "<leader>fl", builtin.lsp_references, { desc = "Telescope LSPs" })

		pcall(telescope.load_extension, "fzf")
		pcall(telescope.load_extension, "ui-select")
	end,
}
