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
	},
}
