local vim = vim
local config = require 'trim.config'

local M = {}

local has_value = function(tbl, val)
  for _, v in ipairs(tbl) do
    if v == val then
      return true
    end
  end
  return false
end

local init_with_070_plus = function(cfg)
  vim.api.nvim_create_augroup('TrimNvim', { clear = true })
  vim.api.nvim_create_autocmd('BufWritePre', {
    pattern = '*',
    callback = function()
      if not has_value(cfg.disable, vim.bo.filetype) then
        require 'trim.trimmer'.trim()
      end
    end,
    group = 'TrimNvim'
  })
end

local init_without_070_plus = function(cfg)
  vim.notify_once('trim.nvim will soon only work with nvim 0.7.0+', vim.log.levels.WARN)
  vim.cmd [[augroup TrimNvim]]
  vim.cmd [[  autocmd!]]
  if #cfg.disable == 0 then
    vim.cmd [[ autocmd BufWritePre * lua require'trim.trimmer'.trim() ]]
  else
    local disables = {}
    for _, v in pairs(cfg.disable) do
      table.insert(disables, string.format("&filetype != '%s'", v))
    end
    vim.cmd(string.format(
      "  autocmd BufWritePre * if %s | lua require'trim.trimmer'.trim()",
      table.concat(disables, " && ")))
  end
  vim.cmd [[augroup END]]
end

M.setup = function(cfg)
  cfg = cfg or {}
  if not cfg.disable then cfg.disable = config.disable end
  if not cfg.patterns then cfg.patterns = config.patterns end

  if not vim.api.nvim_create_autocmd then
    init_without_070_plus(cfg)
  else
    init_with_070_plus(cfg)
  end
end

return M
