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
			handlers = {}, -- Let mason-nvim-dap set up the default configs for codelldb
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

		-- Standard IDE Debugging Keymaps (Remapped for Terminal Compatibility)
		vim.keymap.set("n", "<leader>b", dap.toggle_breakpoint, { desc = "DAP: Toggle Breakpoint" })
		vim.keymap.set("n", "<leader>dc", dap.continue, { desc = "DAP: Start/Continue" })
		vim.keymap.set("n", "<leader>dn", dap.step_over, { desc = "DAP: Step Over (Next)" })
		vim.keymap.set("n", "<leader>di", dap.step_into, { desc = "DAP: Step Into" })
		vim.keymap.set("n", "<leader>do", dap.step_out, { desc = "DAP: Step Out" })

		-- Custom UI Toggle
		vim.keymap.set("n", "<leader>du", dapui.toggle, { desc = "DAP: Toggle UI" })
	end,
}
