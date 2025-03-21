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
