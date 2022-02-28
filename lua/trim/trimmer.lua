local vim = vim
local api = vim.api
local cfg = require 'trim.config'

local trimmer = {}

trimmer.trim = function()
    local save = vim.fn.winsaveview()
    for _, v in pairs(cfg.patterns) do
        api.nvim_exec(string.format("keepjumps keeppatterns silent! %s", v), false)
    end
    vim.fn.winrestview(save)
end

return trimmer
