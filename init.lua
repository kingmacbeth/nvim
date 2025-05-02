require("renato")

if not os.getenv("TMUX") and os.getenv("TERM_PROGRAM") ~= "Apple_Terminal" then
    if vim.fn.has("nvim") == 1 then
        vim.env.NVIM_TUI_ENABLE_TRUE_COLOR = 1
    end
    if vim.fn.has("termguicolors") == 1 then
        vim.o.termguicolors = true
    end
end
