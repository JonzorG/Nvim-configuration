return {
	"nvim-lualine/lualine.nvim",
	dependencies = { "nvim-tree/nvim-web-devicons" },
	config = function()
		require("lualine").setup({
			options = {
				theme = "auto",
				icons_enabled = true,
			},
			sections = {
				lualine_x = {
					{
						-- Custom component to display the spell language
						function()
							return vim.bo.spelllang
						end,
						-- Only show this component if spelling is turned on
						cond = function()
							return vim.wo.spell
						end,
						icon = "󰓆", -- Nerd font dictionary/spell icon
						color = { fg = "#bb9af7", gui = "bold" }, -- Matches your TokyoNight purple
					},
					"encoding",
					"fileformat",
					"filetype",
				},
			},
		})
	end,
}
