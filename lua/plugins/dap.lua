-- [FILE START: ./lua/plugins/dap.lua] --
return {
	"mfussenegger/nvim-dap",
	dependencies = {
		"rcarriga/nvim-dap-ui", -- Visual UI for the debugger
		"nvim-neotest/nvim-nio", -- Async IO dependency for dap-ui
		"theHamsta/nvim-dap-virtual-text", -- Shows variable values inline
		"jay-babu/mason-nvim-dap.nvim", -- Bridges Mason with DAP
	},
	config = function()
		local dap = require("dap")
		local dapui = require("dapui")

		-- Setup Mason-DAP to auto-install the C/C++ debugger (codelldb)
		require("mason-nvim-dap").setup({
			ensure_installed = { "codelldb" },
			automatic_installation = true,
			handlers = {}, -- Let mason-nvim-dap set up the default configs
		})

		require("nvim-dap-virtual-text").setup()
		dapui.setup()

		-- Automatically open and close the DAP UI when debugging starts/stops
		dap.listeners.after.event_initialized["dapui_config"] = function()
			dapui.open()
		end
		dap.listeners.before.event_terminated["dapui_config"] = function()
			dapui.close()
		end
		dap.listeners.before.event_exited["dapui_config"] = function()
			dapui.close()
		end

		-- Setup Custom Breakpoint Icons & Colors
		vim.fn.sign_define("DapBreakpoint", { text = "●", texthl = "DiagnosticError", linehl = "", numhl = "" })
		vim.fn.sign_define(
			"DapBreakpointCondition",
			{ text = "◆", texthl = "DiagnosticWarn", linehl = "", numhl = "" }
		)
		vim.fn.sign_define("DapLogPoint", { text = "📋", texthl = "DiagnosticInfo", linehl = "", numhl = "" })
		vim.fn.sign_define(
			"DapStopped",
			{ text = "→", texthl = "DiagnosticOk", linehl = "CursorLine", numhl = "DiagnosticOk" }
		)
		vim.fn.sign_define(
			"DapBreakpointRejected",
			{ text = "✖", texthl = "DiagnosticError", linehl = "", numhl = "" }
		)

		-- F-Key Debugging Keymaps (Shifted to F5-F9 to avoid Ubuntu Terminal conflicts)
		vim.keymap.set("n", "<leader>b", dap.toggle_breakpoint, { desc = "DAP: Toggle Breakpoint" })
		vim.keymap.set("n", "<F5>", dap.continue, { desc = "DAP: Start/Continue" })
		vim.keymap.set("n", "<F6>", dap.step_over, { desc = "DAP: Step Over" })
		vim.keymap.set("n", "<F7>", dap.step_into, { desc = "DAP: Step Into" })
		vim.keymap.set("n", "<F8>", dap.step_out, { desc = "DAP: Step Out" })

		-- Custom UI Toggle just in case you need to open/close it manually
		vim.keymap.set("n", "<leader>du", dapui.toggle, { desc = "DAP: Toggle UI" })
	end,
}
