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
		opts = function()
			local actions = require("diffview.actions")

			local function has_conflicts()
				local lines = vim.api.nvim_buf_get_lines(0, 0, -1, false)
				return vim.iter(lines):any(function(l)
					return l:match("^<<<<<<<")
				end)
			end

			-- Resolve one conflict then save only if no conflicts remain
			local function choose(side)
				return function()
					actions.conflict_choose(side)()
					if not has_conflicts() then
						vim.cmd("silent! write")
					end
				end
			end

			-- Resolve all conflicts then always save
			local function choose_all(side)
				return function()
					actions.conflict_choose_all(side)()
					vim.cmd("silent! write")
				end
			end

			return {
				keymaps = {
					diff3 = {
						-- Single conflict: save when it was the last one
						{ "n", "co", choose("ours"),   { desc = "Choose OURS" } },
						{ "n", "ct", choose("theirs"), { desc = "Choose THEIRS" } },
						{ "n", "cb", choose("base"),   { desc = "Choose BASE" } },
						{ "n", "ca", choose("all"),    { desc = "Choose all sides (union)" } },
						-- Whole file: always save immediately
						{ "n", "cO", choose_all("ours"),   { desc = "Choose OURS for all conflicts (save)" } },
						{ "n", "cT", choose_all("theirs"), { desc = "Choose THEIRS for all conflicts (save)" } },
						{ "n", "cB", choose_all("base"),   { desc = "Choose BASE for all conflicts (save)" } },
						{ "n", "cA", choose_all("all"),    { desc = "Choose all sides for all conflicts (save)" } },
					},
				},
			}
		end,
	},
	{
		"lewis6991/gitsigns.nvim",
		event = { "BufReadPre", "BufNewFile" },
		opts = {
			on_attach = function(bufnr)
				local gs = require("gitsigns")
				local function map(mode, l, r, opts)
					opts = opts or {}
					opts.buffer = bufnr
					vim.keymap.set(mode, l, r, opts)
				end

				-- Navigation
				map("n", "]h", function()
					if vim.wo.diff then
						vim.cmd.normal({ "]c", bang = true })
					else
						gs.nav_hunk("next")
					end
				end, { desc = "Next hunk" })
				map("n", "[h", function()
					if vim.wo.diff then
						vim.cmd.normal({ "[c", bang = true })
					else
						gs.nav_hunk("prev")
					end
				end, { desc = "Prev hunk" })

				-- Hunk actions
				map("n", "<leader>gs", gs.stage_hunk, { desc = "Stage hunk" })
				map("v", "<leader>gs", function()
					gs.stage_hunk({ vim.fn.line("."), vim.fn.line("v") })
				end, { desc = "Stage hunk" })
				map("n", "<leader>gu", gs.undo_stage_hunk, { desc = "Undo stage hunk" })
				map("n", "<leader>gr", gs.reset_hunk, { desc = "Reset hunk" })
				map("n", "<leader>gS", gs.stage_buffer, { desc = "Stage buffer" })
				map("n", "<leader>gR", gs.reset_buffer, { desc = "Reset buffer" })
				map("n", "<leader>gp", gs.preview_hunk, { desc = "Preview hunk" })
				map("n", "<leader>gb", function()
					gs.blame_line({ full = true })
				end, { desc = "Blame line" })
				map("n", "<leader>gB", gs.toggle_current_line_blame, { desc = "Toggle line blame" })

				-- Text object: select hunk
				map({ "o", "x" }, "ih", ":<C-U>Gitsigns select_hunk<CR>", { desc = "Select hunk" })
			end,
		},
	},
}
