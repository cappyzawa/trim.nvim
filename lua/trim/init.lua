local vim = vim
local config = require 'trim.config'

local init = {}

init.setup = function(cfg)
    if cfg.disable then config.disable = cfg.disable end

    if cfg.patterns then config.patterns = cfg.patterns end

    vim.cmd [[augroup TrimNvim]]
    vim.cmd [[  autocmd!]]
    if #config.disable == 0 then
        vim.cmd [[ autocmd BufWritePre * lua require'trim.trimmer'.trim() ]]
    else
        local disables = {}
        for _, v in pairs(config.disable) do
            table.insert(disables, string.format("&filetype != '%s'", v))
        end
        vim.cmd(string.format(
                    "  autocmd BufWritePre * if %s | lua require'trim.trimmer'.trim()",
                    table.concat(disables, " && ")))
    end
    vim.cmd [[augroup END]]
end

return init
