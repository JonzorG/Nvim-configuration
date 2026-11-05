return {
	"stevearc/oil.nvim",
	dependencies = { "nvim-tree/nvim-web-devicons" },
	config = function()
		require("oil").setup({
			default_file_explorer = true,

			keymaps = {
				["g?"] = "actions.show_help",
				["<CR>"] = "actions.select",
				["<C-s>"] = "actions.select_vsplit",
				["<C-h>"] = "actions.select_split",
				["<C-t>"] = "actions.select_tab",
				["<C-p>"] = "actions.preview",
				["<C-c>"] = "actions.close",
				["-"] = "actions.parent",
				["_"] = "actions.open_cwd",
				["gx"] = {
					desc = "Extract .tar file",
					callback = function()
						local oil = require("oil")
						local entry = oil.get_cursor_entry()
						local dir = oil.get_current_dir()
						if not entry or entry.type ~= "file" then
							return
						end
						if entry.name:match("%.tar$") or entry.name:match("%.tar%.gz$") then
							vim.fn.system({ "tar", "-xf", dir .. entry.name, "-C", dir })
							vim.notify("Extracted: " .. entry.name, vim.log.levels.INFO)
						else
							vim.notify("Not a .tar file", vim.log.levels.WARN)
						end
					end,
				},
			},
			view_options = {
				show_hidden = true,
			},
		})

		vim.keymap.set("n", "-", "<CMD>Oil<CR>", { desc = "Open Parent Directory" })
	end,
}
