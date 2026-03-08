return {
	{
		"mfussenegger/nvim-dap",
		dependencies = {
			"igorlfs/nvim-dap-view",
		},
		keys = {
			{ "<leader>db", function() require("dap").toggle_breakpoint() end, desc = "Toggle breakpoint" },
			{ "<leader>dc", function() require("dap").continue() end, desc = "Continue" },
			{ "<leader>di", function() require("dap").step_into() end, desc = "Step into" },
			{ "<leader>do", function() require("dap").step_over() end, desc = "Step over" },
			{ "<leader>dO", function() require("dap").step_out() end, desc = "Step out" },
			{ "<leader>dr", function() require("dap").restart() end, desc = "Restart" },
			{ "<leader>dt", function() require("dap").terminate() end, desc = "Terminate" },
			{ "<leader>du", function() require("dap-view").toggle() end, desc = "Toggle DAP view" },
		},
		config = function()
			local dap = require("dap")
			local dapview = require("dap-view")
			dapview.setup()

			dap.listeners.after.event_initialized["dapview_config"] = function()
				dapview.open()
			end
			dap.listeners.before.event_terminated["dapview_config"] = function()
				dapview.close()
			end
			dap.listeners.before.event_exited["dapview_config"] = function()
				dapview.close()
			end
		end,
	},
}
