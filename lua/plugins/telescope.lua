return {
	"nvim-telescope/telescope.nvim",
	branch = "master",
	dependencies = {
		"nvim-lua/plenary.nvim",
		{ "nvim-telescope/telescope-fzf-native.nvim", build = "make" },
	},
	config = function()
		local telescope = require("telescope")
		local actions = require("telescope.actions")
		local action_layout = require("telescope.actions.layout")

		local function toggle_layout(prompt_bufnr)
			action_layout.cycle_layout_next(prompt_bufnr)
		end

		telescope.setup({
			defaults = {
				path_display = { "filename_first" },
				layout_strategy = "horizontal",
				file_ignore_patterns = {
					"%.o",
					"%.out",
					"%.class",
					"%.zip",
					"%.tar",
				},
				layout_config = {
					horizontal = { preview_width = 0.55 },
					vertical = { mirror = false },
				},
				mappings = {
					i = {
						["<C-j>"] = actions.preview_scrolling_down,
						["<C-k>"] = actions.preview_scrolling_up,
						["<M-l>"] = toggle_layout,
					},
					n = {
						["<C-j>"] = actions.preview_scrolling_down,
						["<C-k>"] = actions.preview_scrolling_up,
						["<M-l>"] = toggle_layout,
					},
				},
			},
		})

		-- Load the FZF extension into Telescope
		telescope.load_extension("fzf")
	end,
}
