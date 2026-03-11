vim.filetype.add({
	filename = {
		Brewfile = "ruby",
		[".Brewfile"] = "ruby",
	},
})

vim.diagnostic.config({
	virtual_lines = true,
	signs = true,
	underline = true,
	severity_sort = true,
})

local lsps_to_enable = { "lua_ls", "ts_ls", "eslint", "ruby_lsp", "cssls" }

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
		vim.keymap.set("n", "K", vim.lsp.buf.hover, opts)
	end,
})
