return {
	"neovim/nvim-lspconfig",
	dependencies = {
		"stevearc/conform.nvim",
		"williamboman/mason.nvim",
		"williamboman/mason-lspconfig.nvim",
		"hrsh7th/cmp-nvim-lsp",
		"hrsh7th/cmp-buffer",
		"hrsh7th/cmp-path",
		"hrsh7th/cmp-cmdline",
		"hrsh7th/nvim-cmp",
		"L3MON4D3/LuaSnip",
		"j-hui/fidget.nvim",
	},

	config = function()
		require("conform").setup({
			formatters_by_ft = {
			}
		})
		local has_lspconfig, lspconfig = pcall(require, "lspconfig")
		local cmp = require('cmp')
		local cmp_lsp = require("cmp_nvim_lsp")
		local capabilities = vim.tbl_deep_extend(
			"force",
			{},
			vim.lsp.protocol.make_client_capabilities(),
			cmp_lsp.default_capabilities())

		require("fidget").setup({})
		require("mason").setup()
		require("mason-lspconfig").setup({
			ensure_installed = {
				"lua_ls",
				"rust_analyzer",
				"clangd",
			},
			handlers = {
				function(server_name) -- default handler (optional)
					require("lspconfig")[server_name].setup {
						capabilities = capabilities
					}
				end,
			}

		})
		local cmp_select = { behavior = cmp.SelectBehavior.Select }

		cmp.setup({
			mapping = cmp.mapping.preset.insert({
				['<C-p>'] = cmp.mapping.select_prev_item(cmp_select),
				['<C-n>'] = cmp.mapping.select_next_item(cmp_select),
				['<C-y>'] = cmp.mapping.confirm({ select = true }),
				["<C-Space>"] = cmp.mapping.complete(),
			}),
			sources = cmp.config.sources({
				{ name = "copilot", group_index = 2 },
				{ name = 'nvim_lsp' },
			}, {
					{ name = 'buffer' },
				})
		})

		vim.diagnostic.config({
			-- update_in_insert = true,
			float = {
				focusable = false,
				style = "minimal",
				border = "rounded",
				source = "always",
				header = "",
				prefix = "",
			},
		})

		-- Clangd
		lspconfig.clangd.setup({
	--		on_attach = lsp_attach,
			capabilities = capabilities,
			cmd = {
           			"clangd",
--				"--all-scoped-completion",
           			"--background-index",
          			"--clang-tidy",
            			"--header-insertion=iwyu",
           			"--completion-style=detailed",
--            			"--function-arg-placeholders",
--            			"--fallback-style=llvm",
          		},
--		        init_options = {
--        			usePlaceholders = true,
--        			completeUnimported = true,
--        			clangdFileStatus = true,
--      			},
			filetypes = { "c", "cpp", "objc", "objcpp", "cuda", "proto" },
			root_dir = lspconfig.util.root_pattern(
				--'.clangd',
				--'.clang-tidy',
				--'.clang-format',
				'compile_commands.json',
				--'compile_flags.txt',
				--'configure.ac',
				'.git'
			),
			single_file_support = true,
		})
	end
}
