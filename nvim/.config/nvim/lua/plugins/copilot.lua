return {
	"zbirenbaum/copilot.lua",
	cmd = "Copilot",
	event = "InsertEnter",
	cond = function()
		return not vim.g.vscode
	end,
	opts = {
		copilot_model = "claude-sonnet-4-6",
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
