return {
	-- 1. GITSIGNS: Visual indicators in the gutter
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

			-- Keymaps for jumping between changes
			vim.keymap.set("n", "]c", ":Gitsigns next_hunk<CR>", { desc = "Next Git Change" })
			vim.keymap.set("n", "[c", ":Gitsigns prev_hunk<CR>", { desc = "Previous Git Change" })
		end,
	},

	-- 2. LAZYGIT: The best Git UI for Neovim
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
			vim.keymap.set("n", "<leader>gb", ":Gitsigns toggle_current_line_blame<CR>", { desc = "Toggle Git Blame" }),
		},
	},
}
