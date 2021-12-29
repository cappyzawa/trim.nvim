local vim = vim
local api = vim.api
local cfg = require 'trim.config'

local trimmer = {
    trim = function()
        local save = vim.fn.winsaveview()
        for _, v in pairs(cfg.patterns) do
            api.nvim_exec(string.format("silent! %s", v), false)
        end
        vim.fn.winrestview(save)

        api.nvim_add_user_command('Trim1', 'echo "Hello"', {})
    end

}

return trimmer
