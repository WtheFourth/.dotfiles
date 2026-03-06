vim.g.mapleader = " "
vim.o.number = true
vim.o.relativenumber = true
vim.o.signcolumn = "yes"
vim.o.tabstop = 4
vim.o.cursorline = true
vim.o.clipboard = "unnamedplus"
vim.o.ignorecase = true
vim.o.smartcase = true
vim.o.splitright = true
vim.o.splitbelow = true
vim.o.scrolloff = 8
vim.o.undofile = true
vim.o.inccommand = "split"
vim.o.completeopt = "menuone,noselect,popup"
vim.o.termguicolors = true
vim.o.winborder = "single"

if vim.g.vscode then
	return
end

vim.filetype.add({
	filename = {
		Brewfile = "ruby",
		[".Brewfile"] = "ruby",
	},
})

-- Plugins
vim.pack.add({
	{ src = "https://github.com/folke/tokyonight.nvim" },
	{ src = "https://github.com/folke/which-key.nvim" },
	{ src = "https://github.com/neovim/nvim-lspconfig" },
	{ src = "https://github.com/nvim-mini/mini.icons" },
	{ src = "https://github.com/stevearc/conform.nvim" },
	{ src = "https://github.com/williamboman/mason.nvim" },
	{ src = "https://github.com/williamboman/mason-lspconfig.nvim" },
	{ src = "https://github.com/WhoIsSethDaniel/mason-tool-installer.nvim" },
	{ src = "https://github.com/sindrets/diffview.nvim" },
	{ src = "https://github.com/github/copilot.vim" },
	{ src = "https://github.com/saghen/blink.cmp", version = vim.version.range("^1") },
	{ src = "https://github.com/nvim-treesitter/nvim-treesitter" },
	{ src = "https://github.com/ibhagwan/fzf-lua" },
	{ src = "https://github.com/stevearc/oil.nvim" },
	{ src = "https://github.com/echasnovski/mini.starter" },
	{ src = "https://github.com/echasnovski/mini.statusline" },
	{ src = "https://github.com/seblyng/roslyn.nvim" },
	{ src = "https://github.com/mfussenegger/nvim-dap" },
	{ src = "https://github.com/rcarriga/nvim-dap-ui" },
	{ src = "https://github.com/nvim-neotest/nvim-nio" },
})

-- Theme
require("tokyonight").setup({
	on_highlights = function(highlights, colors)
		highlights.CursorLineNr = { fg = colors.yellow }
	end,
})
vim.cmd.colorscheme("tokyonight")

-- Statusline
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

-- Start screen
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

-- Completion
require("blink.cmp").setup({
	keymap = { preset = "default" },
	appearance = { nerd_font_variant = "mono" },
	completion = { documentation = { auto_show = true } },
	sources = { default = { "lsp", "path", "snippets", "buffer" } },
	fuzzy = { implementation = "prefer_rust_with_warning" },
})

-- Treesitter (run :TSInstallAll to install/update parsers)
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

-- Diagnostics
vim.diagnostic.config({
	virtual_lines = true,
	signs = true,
	underline = true,
	severity_sort = true,
})

-- LSP
local lsps_to_enable = { "lua_ls", "ts_ls", "eslint", "ruby_lsp", "cssls" }

require("mason").setup({
	registries = {
		"github:mason-org/mason-registry",
		"github:Crashdummyy/mason-registry",
	},
})
require("mason-lspconfig").setup({ ensure_installed = lsps_to_enable })
require("mason-tool-installer").setup({
	ensure_installed = { "prettierd", "prettier", "rubocop", "stylua" },
})
vim.lsp.enable(lsps_to_enable)

require("roslyn").setup({})

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

-- Formatting
require("conform").setup({
	formatters_by_ft = {
		lua = { "stylua" },
		ruby = { "rubocop" },
		javascript = { "prettierd", "prettier", stop_after_first = true },
		typescript = { "prettierd", "prettier", stop_after_first = true },
		typescriptreact = { "prettierd", "prettier", stop_after_first = true },
		javascriptreact = { "prettierd", "prettier", stop_after_first = true },
		html = { "prettierd", "prettier", stop_after_first = true },
		css = { "prettierd", "prettier", stop_after_first = true },
		json = { "prettierd", "prettier", stop_after_first = true },
		yaml = { "prettierd", "prettier", stop_after_first = true },
		markdown = { "prettierd", "prettier", stop_after_first = true },
	},
	format_on_save = {
		timeout_ms = 2000,
		lsp_format = "fallback",
	},
})

-- Debug
local dap = require("dap")
local dapui = require("dapui")
dapui.setup()

dap.listeners.after.event_initialized["dapui_config"] = function()
	dapui.open()
end
dap.listeners.before.event_terminated["dapui_config"] = function()
	dapui.close()
end
dap.listeners.before.event_exited["dapui_config"] = function()
	dapui.close()
end

vim.keymap.set("n", "<leader>db", dap.toggle_breakpoint, { desc = "Toggle breakpoint" })
vim.keymap.set("n", "<leader>dc", dap.continue, { desc = "Continue" })
vim.keymap.set("n", "<leader>di", dap.step_into, { desc = "Step into" })
vim.keymap.set("n", "<leader>do", dap.step_over, { desc = "Step over" })
vim.keymap.set("n", "<leader>dO", dap.step_out, { desc = "Step out" })
vim.keymap.set("n", "<leader>dr", dap.restart, { desc = "Restart" })
vim.keymap.set("n", "<leader>dt", dap.terminate, { desc = "Terminate" })
vim.keymap.set("n", "<leader>du", dapui.toggle, { desc = "Toggle DAP UI" })

-- Fuzzy finder
require("fzf-lua").setup({})
vim.keymap.set("n", "<C-p>", "<cmd>FzfLua files<cr>", { desc = "Find files" })
vim.keymap.set("n", "<leader>ff", "<cmd>FzfLua git_files<cr>", { desc = "Find git files" })
vim.keymap.set("n", "<leader>fg", "<cmd>FzfLua live_grep<cr>", { desc = "Live grep" })
vim.keymap.set("n", "<leader>fb", "<cmd>FzfLua buffers<cr>", { desc = "Buffers" })
vim.keymap.set("n", "<leader>fh", "<cmd>FzfLua helptags<cr>", { desc = "Help tags" })
vim.keymap.set("n", "<leader>fk", "<cmd>FzfLua keymaps<cr>", { desc = "Keymaps" })
vim.keymap.set("n", "<leader>fr", "<cmd>FzfLua oldfiles<cr>", { desc = "Recent files" })

-- File explorer
require("oil").setup()
vim.keymap.set("n", "-", "<cmd>Oil<cr>", { desc = "Open file explorer" })

-- Keymaps
vim.keymap.set("n", "<Esc>", "<cmd>nohlsearch<cr>", { desc = "Clear search highlight" })
vim.keymap.set("n", "<C-h>", "<C-w>h", { desc = "Move to left split" })
vim.keymap.set("n", "<C-j>", "<C-w>j", { desc = "Move to below split" })
vim.keymap.set("n", "<C-k>", "<C-w>k", { desc = "Move to above split" })
vim.keymap.set("n", "<C-l>", "<C-w>l", { desc = "Move to right split" })
vim.keymap.set("n", "<leader>o", ":update<CR> :source<CR>", { desc = "Update & source" })
vim.keymap.set("n", "<leader>ccl", "gcc", { desc = "Comment line", remap = true })
vim.keymap.set("v", "c", "gc", { desc = "Comment", remap = true })
vim.keymap.set({ "n", "v", "x" }, "<leader>cf", function()
	require("conform").format({ async = true, lsp_fallback = true })
end, { desc = "Format" })
vim.keymap.set("n", "<leader>gd", "<cmd>DiffviewOpen<cr>", { desc = "Diffview open" })
vim.keymap.set("n", "<leader>gh", "<cmd>DiffviewFileHistory %<cr>", { desc = "Diffview file history" })
vim.keymap.set("n", "<leader>gH", "<cmd>DiffviewFileHistory<cr>", { desc = "Diffview branch history" })
vim.keymap.set("n", "<leader>gq", "<cmd>DiffviewClose<cr>", { desc = "Diffview close" })

require("which-key").add({
	{ "<leader>c", group = "Code" },
	{ "<leader>cc", group = "Comment" },
	{ "<leader>f", group = "Find" },
	{ "<leader>d", group = "Debug" },
	{ "<leader>g", group = "Git" },
})

-- Commands
vim.api.nvim_create_user_command("PackClean", function()
	vim.pack.del(vim.iter(vim.pack.get())
		:filter(function(x)
			return not x.active
		end)
		:map(function(x)
			return x.spec.name
		end)
		:totable())
end, {})
