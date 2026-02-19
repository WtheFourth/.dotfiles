return {
	"zbirenbaum/copilot.lua",
	cmd = "Copilot",
	event = "InsertEnter",
	cond = function()
		return not vim.g.vscode
	end,
	opts = {
		suggestion = {
			enabled = true,
			auto_trigger = true,
			keymap = {
				accept = false,
				next = "<M-]>",
				prev = "<M-[>",
				dismiss = "<M-h>",
			},
		},
	},
}
