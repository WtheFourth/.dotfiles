return {
	{
		"mfussenegger/nvim-dap",
		dependencies = {
			"igorlfs/nvim-dap-view",
			"theHamsta/nvim-dap-virtual-text",
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
			require("nvim-dap-virtual-text").setup()

			dap.listeners.after.event_initialized["dapview_config"] = function()
				dapview.open()
			end
			dap.listeners.before.event_terminated["dapview_config"] = function()
				dapview.close()
			end
			dap.listeners.before.event_exited["dapview_config"] = function()
				dapview.close()
			end

			-- C# via netcoredbg
			local netcoredbg_path = vim.fn.exepath("netcoredbg")
			if netcoredbg_path == nil or netcoredbg_path == "" then
				-- Try Mason's default install location as a fallback
				local mason_netcoredbg = vim.fn.stdpath("data") .. "/mason/bin/netcoredbg"
				if vim.fn.filereadable(mason_netcoredbg) == 1 or vim.fn.executable(mason_netcoredbg) == 1 then
					netcoredbg_path = mason_netcoredbg
				else
					vim.notify(
						"netcoredbg executable not found. Please install it (e.g. via Mason) or add it to your PATH.",
						vim.log.levels.ERROR
					)
				end
			end
			dap.adapters.coreclr = {
				type = "executable",
				command = netcoredbg_path,
				args = { "--interpreter=vscode" },
			}
			dap.configurations.cs = {
				{
					type = "coreclr",
					name = "Launch",
					request = "launch",
					program = function()
						return vim.fn.input("Path to dll: ", vim.fn.getcwd() .. "/bin/Debug/", "file")
					end,
				},
				{
					type = "coreclr",
					name = "Attach",
					request = "attach",
					processId = require("dap.utils").pick_process,
				},
			}

			-- TypeScript / JavaScript via vscode-js-debug (js-debug-adapter)
			local js_debug_adapter = vim.fn.exepath("js-debug-adapter")
			if js_debug_adapter == "" then
				js_debug_adapter = "js-debug-adapter"
			end
			dap.adapters["pwa-node"] = {
				type = "server",
				host = "localhost",
				port = "${port}",
				executable = {
					command = js_debug_adapter,
					args = { "${port}" },
				},
			}
			for _, lang in ipairs({ "typescript", "javascript", "typescriptreact", "javascriptreact" }) do
				dap.configurations[lang] = {
					{
						type = "pwa-node",
						request = "launch",
						name = "Launch file",
						program = "${file}",
						cwd = "${workspaceFolder}",
					},
					{
						type = "pwa-node",
						request = "attach",
						name = "Attach",
						processId = require("dap.utils").pick_process,
						cwd = "${workspaceFolder}",
					},
				}
			end
		end,
	},
}
