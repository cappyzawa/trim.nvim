local vim = vim
local config = require 'trim.config'
local trimmer = require 'trim.trimmer'

local M = {}

local has_value = function(tbl, val)
  for _, v in ipairs(tbl) do
    if v == val then
      return true
    end
  end
  return false
end

M.setup = function(cfg)
  cfg = cfg or {}
  if not cfg.disable then cfg.disable = config.disable end
  if not cfg.patterns then cfg.patterns = config.patterns end

  if not vim.api.nvim_create_autocmd then
    vim.notify_once('trim.nvim requires nvim 0.7.0+.', vim.log.levels.ERROR)
  else
    vim.api.nvim_create_augroup('TrimNvim', { clear = true })
    vim.api.nvim_create_autocmd('BufWritePre', {
      pattern = '*',
      callback = function()
        if not has_value(cfg.disable, vim.bo.filetype) then
          trimmer.trim(cfg.patterns)
        end
      end,
      group = 'TrimNvim'
    })
  end
end

return M
