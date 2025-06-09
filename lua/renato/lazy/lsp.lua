return {
    "neovim/nvim-lspconfig",
    dependencies = {
        "folke/lazydev.nvim",
        "stevearc/conform.nvim",
        "williamboman/mason.nvim",
        "williamboman/mason-lspconfig.nvim",
        "WhoIsSethDaniel/mason-tool-installer.nvim",
        "hrsh7th/cmp-nvim-lsp",
        "hrsh7th/cmp-buffer",
        "hrsh7th/cmp-path",
        "hrsh7th/cmp-cmdline",
        "hrsh7th/nvim-cmp",
        "j-hui/fidget.nvim",
    },


    config = function()
        require("conform").setup({
            formatters_by_ft = {
                python = { "isort" },
            },
            format_on_save = {
                lsp_fallback = true,
                timeout_ms = 1000,
            },
        })
        local cmp = require('cmp')
        local cmp_lsp = require("cmp_nvim_lsp")
        local capabilities = vim.tbl_deep_extend(
            "force",
            {},
            vim.lsp.protocol.make_client_capabilities(),
            cmp_lsp.default_capabilities())

        require("fidget").setup({})

        local lspconfig = require('lspconfig')
        lspconfig.ts_ls.setup({
            capabilities = capabilities,
            on_attach = function(client, _)
                client.server_capabilities.documentFormattingProvider = false
            end,
            settings = {
                typescript = {
                    format = {
                        indentSize = 2,
                        convertTabsToSpaces = true,
                    },
                    inlayHints = {
                        includeInlayParameterNameHints = "all",
                        includeInlayParameterNameHintsWhenArgumentMatchesName = false,
                        includeInlayFunctionParameterTypeHints = true,
                        includeInlayVariableTypeHints = true,
                        includeInlayPropertyDeclarationTypeHints = true,
                        includeInlayFunctionLikeReturnTypeHints = true,
                        includeInlayEnumMemberValueHints = true,
                    },
                },
                javascript = {
                    format = {
                        indentSize = 2,
                        convertTabsToSpaces = true,
                    },
                },
            },
        })

        local null_ls = require("null-ls")
        null_ls.setup({
            sources = {
                null_ls.builtins.formatting.prettier.with({
                    extra_args = { "--tab-width", "2" },
                    filetypes = {
                        "typescript", "typescriptreact",
                        "javascript", "javascriptreact",
                    },
                }),
            },
            on_attach = function(client, bufnr)
                if client.supports_method("textDocument/formatting") then
                    vim.api.nvim_clear_autocmds({ group = "LspFormatting", buffer = bufnr })
                    vim.api.nvim_create_autocmd("BufWritePre", {
                        group = vim.api.nvim_create_augroup("LspFormatting", { clear = true }),
                        buffer = bufnr,
                        callback = function()
                            vim.lsp.buf.format({
                                async = false,
                                filter = function(c)
                                    return c.name == "null-ls"
                                end,
                            })
                        end,
                    })
                end
            end,
        })

        lspconfig.rust_analyzer.setup({
            capabilities = capabilities,
            settings = {
                ["rust-analyzer"] = {
                    cargo = {
                        allFeatures = true,
                        loadOutDirsFromCheck = true,
                    },
                    checkOnSave = true,
                    diagnostics = {
                        enable = true,
                        disabled = { "unresolved-proc-macro" },
                        enableExperimental = true,
                    },
                    procMacro = {
                        enable = true,
                    },
                    inlayHints = {
                        bindingModeHints = { enable = true },
                        closureReturnTypeHints = { enable = "always" },
                        lifetimeElisionHints = {
                            enable = true,
                            useParameterNames = true,
                        },
                    },
                },
            },
        })
        lspconfig.ruff.setup({
            capabilities = capabilities,
            on_attach = function(client, _)
                client.server_capabilities.documentFormattingProvider = true
            end,
            settings = {
                args = { "--config=pyproject.toml" }
            },
        })
        lspconfig.pyright.setup({
            capabilities = capabilities,
            on_attach = function(client, _)
                client.server_capabilities.documentFormattingProvider = false
            end,
            settings = {
                python = {
                    analysis = {
                        typeCheckingMode = "basic",
                        autoSearchPaths = true,
                        useLibraryCodeForTypes = true,
                        diagnosticMode = "openFilesOnly",
                        reportMissingImports = true,
                        reportUndefinedVariable = true,
                    },
                    pythonPath = vim.fn.exepath("python3"),
                },
            },
        })
        lspconfig.gopls.setup({
            capabilities = capabilities,
            settings = {
                gopls = {
                    ["ui.inlayhint.hints"] = {
                        compositeLiteralFields = true,
                        constantValues = true,
                        parameterNames = true,
                    },
                },
            },
        })
        lspconfig.lua_ls.setup {
            capabilities = capabilities,
            settings = {
                Lua = {
                    runtime = {
                        version = 'LuaJIT',
                    },
                    format = {
                        enable = true,
                        defaultConfig = {
                            indent_style = "space",
                            indent_size = "2",
                        }
                    },
                    diagnostics = {
                        globals = {
                            'vim',
                            'require'
                        },
                    },
                    workspace = {
                        library = vim.api.nvim_get_runtime_file("", true),
                    },
                    telemetry = {
                        enable = false,
                    },
                },
            },
        }


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
            virtual_text = true,
            float = {
                focusable = false,
                style = "minimal",
                border = "rounded",
                source = true,
                header = "",
                prefix = "",
            },
        })
        require("mason").setup()
        require("mason-lspconfig").setup()
    end
}
