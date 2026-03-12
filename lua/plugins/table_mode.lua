return {
	"dhruvasagar/vim-table-mode",
	ft = { "text", "markdown" },
	keys = {
		{ "<leader>tm", "<cmd>TableModeToggle<cr>", desc = "Toggle Table Mode" },
		{ "<leader>tt", "<cmd>TableModeFormat<cr>", desc = "Format Table" },
	},
	config = function()
		vim.g.table_mode_corner = "|"
	end,
}
