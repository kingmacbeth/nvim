require("renato.set")
require("renato.remap")
require("renato.lazy_init")
require("renato.lsp_remap")

local augroup = vim.api.nvim_create_augroup
local autocmd = vim.api.nvim_create_autocmd

local RenatoGroup = augroup('Renato', {})
local yank_group = augroup('HighlightYank', {})
local lsp_group = augroup('lsp', { clear = true })

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

autocmd('LspAttach', {
    group = lsp_group,
    callback = function(args)
        autocmd("BufWritePre", {
            buffer = args.buf,
            callback = function()
                vim.lsp.buf.format {
                    async = false,
                    id = args.data.client_id
                }
            end,
        })
    end
})

autocmd({ "BufWritePre" }, {
    group = RenatoGroup,
    pattern = "*",
    command = [[%s/\s\+$//e]],
})
