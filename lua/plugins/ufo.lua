return {
	"kevinhwang91/nvim-ufo",
	dependencies = { "kevinhwang91/promise-async" },
	event = "BufReadPost",
	init = function()
		vim.o.foldlevel = 99
		vim.o.foldlevelstart = 99
		vim.o.foldenable = true
	end,
	config = function()
		require("ufo").setup({
			provider_selector = function(bufnr, filetype, buftype)
				return { "treesitter", "indent" }
			end,
		})

		vim.keymap.set("n", "zR", require("ufo").openAllFolds, { desc = "Open all folds" })
		vim.keymap.set("n", "zM", require("ufo").closeAllFolds, { desc = "Close all folds" })
		vim.keymap.set("n", "zc", "zc", { desc = "Fold: Close current fold" })
		vim.keymap.set("n", "zo", "zo", { desc = "Fold: Open current fold" })
		vim.keymap.set("n", "za", "za", { desc = "Fold: Toggle current fold" })
		vim.keymap.set("n", "zC", "zC", { desc = "Fold: Close folds recursively" })
		vim.keymap.set("n", "zO", "zO", { desc = "Fold: Open folds recursively" })
		vim.keymap.set("n", "zA", "zA", { desc = "Fold: Toggle folds recursively" })
	end,
}
