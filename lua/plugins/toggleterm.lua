return {
	"akinsho/toggleterm.nvim",
	version = "*",
	opts = {
		size = 15,
		open_mapping = [[<c-\>]],
		hide_numbers = true,
		shade_terminals = true,
		shading_factor = 2,
		start_in_insert = true,
		insert_mappings = true,
		persist_size = true,
		direction = "float",
		close_on_exit = true,
		shell = vim.o.shell,
		float_opts = {
			border = "curved",
			winblend = 0,
		},
	},
	keys = {
		{ "<c-\\>", "<cmd>ToggleTerm<cr>", desc = "Terminal: Toggle Default" },
		{ "<leader>t1", "<cmd>1ToggleTerm direction=float<cr>", desc = "Terminal: Float 1" },
		{ "<leader>t2", "<cmd>2ToggleTerm direction=float<cr>", desc = "Terminal: Float 2" },
		{ "<leader>t3", "<cmd>3ToggleTerm direction=horizontal<cr>", desc = "Terminal: Horizontal 3" },
	},
}
