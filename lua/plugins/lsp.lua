return {
	{
		"williamboman/mason.nvim",
		dependencies = {
			"whoissethdaniel/mason-tool-installer.nvim",
		},
		config = function()
			local mason = require("mason")
			local mason_tool_installer = require("mason-tool-installer")

			mason.setup()

			mason_tool_installer.setup({
				ensure_installed = {
					"isort",
					"black",
					"stylua",
					"pylint",
				},
			})
		end,
	},
	{
		"neovim/nvim-lspconfig",
		dependencies = {
			"williamboman/mason-lspconfig.nvim",
			"hrsh7th/cmp-nvim-lsp",
		},
		config = function()
			require("mason-lspconfig").setup({
				ensure_installed = { "clangd", "pyright", "lua_ls", "sqls" },
			})
			vim.api.nvim_create_autocmd("LspAttach", {
				desc = "LSP actions",
				callback = function(event)
					local opts = { buffer = event.buf, noremap = true, silent = true }
					vim.keymap.set("n", "K", vim.lsp.buf.hover, opts)
					vim.keymap.set("n", "gd", vim.lsp.buf.definition, opts)
					vim.keymap.set("n", "<leader>ca", vim.lsp.buf.code_action, opts)
				end,
			})
		end,
	},
}
