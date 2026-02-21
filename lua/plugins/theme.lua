return {
	{ "folke/tokyonight.nvim", lazy = false, priority = 1000 },
	{ "catppuccin/nvim", name = "catppuccin", lazy = false, priority = 1000 },
	{
		"rebelot/kanagawa.nvim",
		lazy = false,
		priority = 1000,
		config = function()
			-- Change this string to set your default startup theme!
			-- Try: "catppuccin-mocha", "kanagawa", or "tokyonight-night"
			vim.cmd.colorscheme("tokyonight-night")
		end,
	},
}
