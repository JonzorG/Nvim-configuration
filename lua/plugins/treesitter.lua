return {
	"nvim-treesitter/nvim-treesitter",
	branch = "master",
	build = ":TSUpdate",
	config = function()
		local configs = require("nvim-treesitter.configs")

		configs.setup({
			ensure_installed = { "c", "cpp", "python", "lua", "vim", "vimdoc", "query", "sql" },
			sync_install = false,
			highlight = { enable = true },
			indent = { enable = true },
		})
	end,
}
