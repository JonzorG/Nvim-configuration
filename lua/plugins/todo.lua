return {
	"folke/todo-comments.nvim",
	dependencies = { "nvim-lua/plenary.nvim" },
	opts = {
		highlight = { keyword = "bg" },
	},
	keys = {
		{
			"]t",
			function()
				require("todo-comments").jump_next()
			end,
			desc = "Jump to Next TODO",
		},
		{
			"[t",
			function()
				require("todo-comments").jump_prev()
			end,
			desc = "Jump to Previous TODO",
		},
		{ "<leader>st", "<cmd>TodoTelescope<cr>", desc = "Search: TODO Comments" },
	},
}
