--Bootstrap lazy.nvim
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
	local lazyrepo = "https://github.com/folke/lazy.nvim.git"
	local out = vim.fn.system({ "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath })
	if vim.v.shell_error ~= 0 then
		vim.api.nvim_echo({
			{ "Failed to clone lazy.nvim:\n", "ErrorMsg" },
			{ out, "WarningMsg" },
			{ "\nPress any key to exit..." },
		}, true, {})
		vim.fn.getchar()
		os.exit(1)
	end
end
vim.opt.rtp:prepend(lazypath)

-- Make sure to setup `mapleader` and `maplocalleader` before
-- loading lazy.nvim so that mappings are correct.
-- This is also a good place to setup other settings (vim.opt)
vim.g.mapleader = " "
vim.g.maplocalleader = "\\"

-- Setup lazy.nvim
require("lazy").setup({
	spec = {
		-- import your plugins
		{ import = "plugins" },
		-- import themes
		{ import = "themes" },
	},
	-- automatically check for plugin updates
	checker = { enabled = true },
})

-- setting up mini plugins
if not vim.g.vscode then
	local mini_modules = {
		{ name = "ai", config = {} },
		{ name = "clue", config = {} },
		{ name = "diff", config = {} },
		{
			name = "files",
			config = { mappings = { go_in_plus = "<CR>" } },
			config_callback = function()
				vim.keymap.set("n", "<leader>F", MiniFiles.open)
			end,
		},
		{ name = "git", config = {} },
		{ name = "icons", config = {} },
		{ name = "statusline", config = {} },
	}

	for _, module in ipairs(mini_modules) do
		local ok, m = pcall(require, "mini." .. module.name)
		if ok then
			m.setup(module.config)
			if module.config_callback then
				module.config_callback(m)
			end
		else
			print("Failed to load mini." .. module.name)
		end
	end
end
