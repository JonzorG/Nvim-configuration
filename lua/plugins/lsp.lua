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
					vim.keymap.set("n", "<leader>sh", function()
						local params = vim.lsp.util.make_text_document_params(event.buf)
						vim.lsp.buf_request(event.buf, "textDocument/switchSourceHeader", params, function(err, result)
							if err then
								error(tostring(err))
							end
							if not result then
								vim.notify("Corresponding file not found", vim.log.levels.WARN)
								return
							end
							vim.cmd("edit " .. vim.uri_to_fname(result))
						end)
					end, vim.tbl_extend("force", opts, { desc = "LSP: Switch Source/Header" }))
				end,
			})
		end,
	},
}
