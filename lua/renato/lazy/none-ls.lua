local augroup = vim.api.nvim_create_augroup("LspFormatting", { clear = true })

return {
    'nvimtools/none-ls.nvim',
    dependencies = { 'nvim-lua/plenary.nvim' },
    config = function()
        local null_ls = require("null-ls")

        null_ls.setup({
            sources = {
                null_ls.builtins.formatting.prettier.with({
                    extra_args = { "--tab-width", "2" },
                    filetypes = { "typescript", "typescriptreact", "javascript", "javascriptreact" },
                }),
            },
            on_attach = function(client, bufnr)
                if client.supports_method("textDocument/formatting") then
                    vim.api.nvim_clear_autocmds({ group = augroup, buffer = bufnr })
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
    end
}
