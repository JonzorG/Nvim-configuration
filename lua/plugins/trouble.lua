return {
	"folke/trouble.nvim",
	dependencies = { "nvim-tree/nvim-web-devicons" },
	cmd = "Trouble",
	opts = {},
	keys = {
		{
			"<leader>xx",
			function()
				if #vim.diagnostic.get(0) == 0 then
					vim.notify("Clean file! No diagnostics found.", vim.log.levels.INFO)
				else
					vim.cmd("Trouble diagnostics toggle")
				end
			end,
			desc = "Diagnostics (Trouble)",
		},
		{
			"<leader>xq",
			"<cmd>Trouble qflist toggle<cr>",
			desc = "Quickfix List (Trouble)",
		},
	},
}
