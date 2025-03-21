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
--#region Quickfix
vim.keymap.set("n", "<leader>cc", toggle_qf, { desc = "Toggle Quickfix window" })
--#endregion

--#region Telescope
local builtin = require("telescope.builtin")
vim.keymap.set("n", "<C-p>", builtin.git_files, { desc = "Telescope find files" })
vim.keymap.set("n", "<leader>fg", builtin.live_grep, { desc = "Telescope live grep" })
vim.keymap.set("n", "<leader>fb", builtin.buffers, { desc = "Telescope buffers" })
vim.keymap.set("n", "<leader>fh", builtin.help_tags, { desc = "Telescope help tags" })
vim.keymap.set("n", "<leader>ft", builtin.treesitter, { desc = "Telescope treesitter" })
vim.keymap.set("n", "<leader>fk", builtin.keymaps, { desc = "Telescope keymaps" })
vim.keymap.set("n", "<leader>fl", builtin.lsp_references, { desc = "Telescope LSPs" })
--#endregion

--#region LSPs
vim.keymap.set("n", "<leader>ca", vim.lsp.buf.code_action)
vim.keymap.set("n", "<leader>cf", vim.lsp.buf.format)
--#endregion

--#endregion

vim.api.nvim_create_autocmd("DiagnosticChanged", {
	callback = function()
		vim.diagnostic.setqflist({ open = false })
	end,
})
