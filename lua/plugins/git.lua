return {
	{
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
		end,
	},

	{
		"kdheepak/lazygit.nvim",
		cmd = {
			"LazyGit",
			"LazyGitConfig",
			"LazyGitCurrentFile",
			"LazyGitFilter",
			"LazyGitFilterCurrentFile",
		},
		dependencies = {
			"nvim-lua/plenary.nvim",
		},
		keys = {
			{ "<leader>lg", "<cmd>LazyGit<cr>", desc = "Open LazyGit" },
			{ "<leader>gb", ":Gitsigns toggle_current_line_blame<CR>", desc = "Toggle Git Blame" },
		},
	},
}
