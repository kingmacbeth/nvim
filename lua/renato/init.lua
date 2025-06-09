require("renato.set")
require("renato.remap")
require("renato.lazy_init")

local augroup = vim.api.nvim_create_augroup
local autocmd = vim.api.nvim_create_autocmd

local RenatoGroup = augroup('Renato', {})
local yank_group = augroup('HighlightYank', {})


function R(name)
    require("plenary.reload").reload_module(name)
end

vim.filetype.add({
    extension = {
        templ = 'templ',
    }
})

autocmd('TextYankPost', {
    group = yank_group,
    pattern = '*',
    callback = function()
        vim.highlight.on_yank({
            higroup = 'IncSearch',
            timeout = 40,
        })
    end,
})

local ts_files = { typescript = true, javascript = true, typescriptreact = true }
autocmd('BufEnter', {
    group = RenatoGroup,
    callback = function()
        local ft = vim.bo.filetype
        if ft == "lua" then
            vim.cmd.colorscheme("tokyonight-night")
        elseif ft == "python" then
            vim.cmd.colorscheme("biscuit")
        elseif ts_files[ft] then
            vim.cmd.colorscheme("onedark")
        elseif ft == "rust" then
            vim.cmd.colorscheme("jellybeans")
        else
            vim.cmd.colorscheme("gruvbox-material")
        end
    end
})

autocmd('LspAttach', {
    group = RenatoGroup,
    callback = function(e)
        autocmd("BufWritePre", {
            group = RenatoGroup,
            buffer = e.buf,
            callback = function()
                vim.lsp.buf.format({
                    async = false,
                    --filter = function(c)
                    --    return c.name == "lua_ls"
                    --end,
                })
            end,
        })

        local opts = { buffer = e.buf }
        vim.keymap.set("n", "gd", function() vim.lsp.buf.definition() end, opts)
        vim.keymap.set("n", "K", function() vim.lsp.buf.hover() end, opts)
        vim.keymap.set("n", "<leader>vws", function() vim.lsp.buf.workspace_symbol() end, opts)
        vim.keymap.set("n", "<leader>vd", function() vim.diagnostic.open_float() end, opts)
        vim.keymap.set("n", "<leader>vca", function() vim.lsp.buf.code_action() end, opts)
        -- vim.keymap.snt("n", "<leader>vrr", function() vim.lsp.buf.references() end, opts)
        vim.keymap.set("n", "<leader>vrn", function() vim.lsp.buf.rename() end, opts)
        vim.keymap.set("i", "<C-h>", function() vim.lsp.buf.signature_help() end, opts)
        vim.keymap.set("n", "[d", function() vim.diagnostic.goto_next() end, opts)
        vim.keymap.set("n", "]d", function() vim.diagnostic.goto_prev() end, opts)
    end
})

vim.g.netrw_browse_split = 0
vim.g.netrw_banner = 0
vim.g.netrw_winsize = 25
