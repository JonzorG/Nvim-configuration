return {
	"nvim-treesitter/nvim-treesitter",
	build = ":TSUpdate",
	config = function()
		local configs = require("nvim-treesitter.config")

		configs.setup({
			ensure_installed = { "c", "cpp", "python", "lua", "vim", "vimdoc", "query", "sql" },
			sync_install = false,
			highlight = { enable = true },
			indent = { enable = true },
		})
	end,
}
