-- checking if we're using WSL, setting up clipboard appropriately
local function is_wsl()
	local sys = vim.fn.system("uname -r")
	return sys:lower():match("wsl") ~= nil
end

if is_wsl() then
	vim.g.clipboard = {
		name = "WslClipboard",
		copy = {
			["+"] = "clip.exe",
			["*"] = "clip.exe",
		},
		paste = {
			["+"] = 'powershell.exe -c [Console]::Out.Write($(Get-Clipboard -Raw).tostring().replace("`r", ""))',
			["*"] = 'powershell.exe -c [Console]::Out.Write($(Get-Clipboard -Raw).tostring().replace("`r", ""))',
		},
		cache_enabled = 0,
	}
end

local toggle_qf = function()
	for _, info in ipairs(vim.fn.getwininfo()) do
		if info.quickfix == 1 then
			vim.cmd("cclose")
			return
		end
	end
	if next(vim.fn.getqflist()) == nil then
		print("Quickfix list empty")
		return
	end
	vim.cmd("copen")
end

vim.o.number = true
vim.o.relativenumber = true
vim.o.shiftwidth = 2
vim.o.expandtab = true
vim.o.clipboard = "unnamedplus"
vim.o.showmode = false
vim.o.inccommand = "split"
vim.g.have_nerd_font = true
vim.o.cursorline = true

require("config.lazy")

--#region LSP
vim.lsp.enable({ "lua_ls", "ts_ls", "cssls", "eslint", "omnisharp" })

vim.api.nvim_create_autocmd("LspAttach", {
	callback = function(ev)
		local opts = { buffer = ev.buf }
		vim.keymap.set("n", "<leader>ca", vim.lsp.buf.code_action, vim.tbl_extend("force", opts, { desc = "Code action" }))
		vim.keymap.set("n", "<leader>cf", vim.lsp.buf.format, vim.tbl_extend("force", opts, { desc = "LSP format" }))
		vim.keymap.set("n", "<leader>cr", vim.lsp.buf.references, vim.tbl_extend("force", opts, { desc = "Show references" }))
		vim.keymap.set("n", "<leader>cd", vim.lsp.buf.definition, vim.tbl_extend("force", opts, { desc = "Go to definition" }))
		vim.keymap.set("n", "<leader>cD", vim.lsp.buf.declaration, vim.tbl_extend("force", opts, { desc = "Go to declaration" }))
		vim.lsp.inlay_hint.enable(true, { bufnr = ev.buf })
	end,
})

vim.diagnostic.config({
	virtual_text = false,
	virtual_lines = true,
})
--#endregion

--#region Keymaps
vim.keymap.set("n", "<leader>cc", toggle_qf, { desc = "Toggle Quickfix window" })
vim.keymap.set("n", "<c-j>", "<c-d>")
vim.keymap.set("n", "<c-k>", "<c-u>")
--#endregion

vim.api.nvim_create_autocmd("DiagnosticChanged", {
	callback = function()
		vim.diagnostic.setqflist({ open = false })
	end,
})
