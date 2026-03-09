return {
	"nvim-telescope/telescope.nvim",
	branch = "master",
	dependencies = {
		"nvim-lua/plenary.nvim",
		{ "nvim-telescope/telescope-fzf-native.nvim", build = "make" },
	},
	keys = {
		{
			"<leader>ff",
			function()
				require("telescope.builtin").find_files()
			end,
			desc = "Search: Files in Root",
		},
		{
			"<leader>fg",
			function()
				require("telescope.builtin").live_grep()
			end,
			desc = "Search: Text (Grep)",
		},
		{
			"<leader>fb",
			function()
				require("telescope.builtin").buffers()
			end,
			desc = "Search: Open Buffers",
		},
		{
			"<leader>sr",
			function()
				require("telescope.builtin").registers({ initial_mode = "normal" })
			end,
			desc = "Search: Registers",
		},
		{
			"<leader>sk",
			function()
				require("telescope.builtin").keymaps({ modes = { "n" } })
			end,
			desc = "Search: Keymap Definitions",
		},
		{
			"<leader>fc",
			function()
				require("telescope.builtin").find_files({ cwd = os.getenv("HOME") .. "/.config/nvim" })
			end,
			desc = "Search: Config Files",
		},
		{
			"<leader>fr",
			function()
				require("telescope.builtin").find_files({ cwd = os.getenv("HOME") .. "/Documents" })
			end,
			desc = "Search: Documents",
		},
		{
			"<leader>sd",
			function()
				require("telescope.builtin").diagnostics({ initial_mode = "normal" })
			end,
			desc = "Search: Diagnostics",
		},
		{
			"<leader>ss",
			function()
				require("telescope.builtin").lsp_document_symbols()
			end,
			desc = "Search: Document Symbols",
		},
		{
			"z=",
			function()
				require("telescope.builtin").spell_suggest(
					require("telescope.themes").get_cursor({ initial_mode = "normal" })
				)
			end,
			desc = "LSP: Spell Suggestions",
		},
		{
			"<leader>th",
			function()
				require("telescope.builtin").colorscheme({ enable_preview = true })
			end,
			desc = "UI: Switch Theme",
		},
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
					"%.gz",
					"%.so",
					"%.pyc",
					"%.npy",
					"%.npz",
					"%.pkl",
					"%.ttf",
					"%.afm",
					"%.pack",
					"%.rev",
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

		telescope.load_extension("fzf")
	end,
}
