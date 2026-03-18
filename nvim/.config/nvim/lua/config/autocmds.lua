vim.filetype.add({
	filename = {
		Brewfile = "ruby",
		[".Brewfile"] = "ruby",
	},
})

vim.diagnostic.config({
	virtual_lines = { current_line = true },
	signs = true,
	underline = true,
	severity_sort = true,
})

local lsps_to_enable = require("config.servers")

vim.api.nvim_create_autocmd("LspDetach", {
	callback = function(ev)
		local buf = ev.buf
		vim.defer_fn(function()
			if vim.api.nvim_buf_is_valid(buf) then
				local ft = vim.bo[buf].filetype
				for _, name in ipairs(lsps_to_enable) do
					local config = vim.lsp.config[name]
					if config and vim.tbl_contains(config.filetypes or {}, ft) then
						vim.lsp.enable(name)
					end
				end
			end
		end, 1000)
	end,
})

vim.api.nvim_create_autocmd("LspAttach", {
	callback = function(ev)
		local opts = { buffer = ev.buf }
		vim.keymap.set(
			"n",
			"<leader>ca",
			vim.lsp.buf.code_action,
			vim.tbl_extend("force", opts, { desc = "Code action" })
		)
		vim.keymap.set(
			"n",
			"<leader>cr",
			vim.lsp.buf.references,
			vim.tbl_extend("force", opts, { desc = "References" })
		)
		vim.keymap.set(
			"n",
			"<leader>cd",
			vim.lsp.buf.definition,
			vim.tbl_extend("force", opts, { desc = "Go to definition" })
		)
		vim.keymap.set(
			"n",
			"<leader>cD",
			vim.lsp.buf.declaration,
			vim.tbl_extend("force", opts, { desc = "Go to declaration" })
		)
		vim.keymap.set("n", "<leader>cn", vim.lsp.buf.rename, vim.tbl_extend("force", opts, { desc = "Rename symbol" }))
		vim.keymap.set("n", "<leader>ci", vim.lsp.buf.implementation, vim.tbl_extend("force", opts, { desc = "Go to implementation" }))
		vim.keymap.set("n", "<leader>ct", vim.lsp.buf.type_definition, vim.tbl_extend("force", opts, { desc = "Go to type definition" }))
		vim.keymap.set("n", "gd", vim.lsp.buf.definition, vim.tbl_extend("force", opts, { desc = "Go to definition" }))
		vim.keymap.set("n", "gr", vim.lsp.buf.references, vim.tbl_extend("force", opts, { desc = "References" }))
		vim.keymap.set("n", "gi", vim.lsp.buf.implementation, vim.tbl_extend("force", opts, { desc = "Go to implementation" }))
		vim.keymap.set("n", "K", vim.lsp.buf.hover, opts)
	end,
})

vim.api.nvim_create_autocmd("DiagnosticChanged", {
	callback = function()
		local diagnostics = vim.diagnostic.get(nil, { severity = vim.diagnostic.severity.ERROR })
		if #diagnostics > 0 then
			require("trouble").open({ mode = "preview_right", focus = false })
		else
			require("trouble").close()
		end
	end,
})

vim.api.nvim_create_user_command("TSInstallAll", function()
	require("nvim-treesitter").install({
		"lua",
		"vim",
		"vimdoc",
		"typescript",
		"javascript",
		"tsx",
		"html",
		"css",
		"ruby",
		"json",
		"yaml",
		"markdown",
		"c_sharp",
	})
end, {})
