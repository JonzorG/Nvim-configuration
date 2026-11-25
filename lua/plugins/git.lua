return {
	"lewis6991/gitsigns.nvim",
	event = { "BufReadPre", "BufNewFile" },
	config = function()
		require("gitsigns").setup({
			current_line_blame = false,
			current_line_blame_opts = {
				delay = 500,
			},
		})

		vim.keymap.set("n", "]c", ":Gitsigns next_hunk<CR>", { desc = "Next Git Change" })
		vim.keymap.set("n", "[c", ":Gitsigns prev_hunk<CR>", { desc = "Previous Git Change" })
		vim.keymap.set("n", "<leader>gb", ":Gitsigns toggle_current_line_blame<CR>", { desc = "Toggle Git Blame" })
	end,
}
