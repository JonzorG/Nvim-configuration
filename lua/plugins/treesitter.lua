return {
	"nvim-treesitter/nvim-treesitter-context",
	event = { "BufReadPost", "BufNewFile" },
	dependencies = { "nvim-treesitter/nvim-treesitter" },
	config = function()
		require("treesitter-context").setup({
			enable = true,
			max_lines = 4,
			min_window_height = 0,
			line_numbers = true,
			multiline_threshold = 1,
			trim_scope = "outer",
			mode = "cursor",
			zindex = 20,

			on_attach = function(buf)
				local max_filesize = 100 * 1024
				local ok, stats = pcall(vim.uv.fs_stat, vim.api.nvim_buf_get_name(buf))
				if ok and stats and stats.size > max_filesize then
					return false
				end
				return true
			end,
		})

		vim.keymap.set("n", "<leader>cx", function()
			require("treesitter-context").toggle()
		end, { desc = "Toggle Treesitter Context" })
	end,
}
