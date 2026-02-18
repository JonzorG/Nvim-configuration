return {
	"goolord/alpha-nvim",
	event = "VimEnter",
	config = function()
		local dashboard = require("alpha.themes.dashboard")
		local function read_ascii(filename)
			local path = vim.fn.stdpath("config") .. "/ascii/" .. filename
			local file = io.open(path, "r")
			if not file then
				return { "Error: File not found: " .. filename }
			end
			local lines = {}
			for line in file:lines() do
				table.insert(lines, line)
			end
			file:close()
			return lines
		end

		local function get_max_width(lines)
			local max_width = 0
			for _, line in ipairs(lines) do
				local width = vim.fn.strdisplaywidth(line)
				if width > max_width then
					max_width = width
				end
			end
			return max_width
		end

		local function center_lines(lines, target_width)
			local centered = {}
			for _, line in ipairs(lines) do
				local width = vim.fn.strdisplaywidth(line)
				local padding = math.floor((target_width - width) / 2)
				table.insert(centered, string.rep(" ", padding) .. line)
			end
			return centered
		end

		local selected_header = read_ascii("header_2.txt")
		local selected_logo = read_ascii("logo_bear.txt")

		local header_width = get_max_width(selected_header)
		local logo_width = get_max_width(selected_logo)
		local target_width = math.max(header_width, logo_width)
		local centered_header = center_lines(selected_header, target_width)
		local centered_logo = center_lines(selected_logo, target_width)

		local merged = vim.list_extend({}, centered_header)
		vim.list_extend(merged, centered_logo)

		dashboard.section.header.val = merged
		dashboard.section.header.opts.hl = "Type"
		dashboard.section.buttons.val = {}
		dashboard.section.footer.val = {}

		require("alpha").setup(dashboard.config)
	end,
}
