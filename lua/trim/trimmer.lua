local vim = vim
local api = vim.api

local trimmer = {}

function trimmer.trim()
  local config = require('trim.config').get()
  local save = vim.fn.winsaveview()
  for _, v in ipairs(config.patterns) do
    api.nvim_exec(string.format('keepjumps keeppatterns silent! %s', v), false)
  end
  vim.fn.winrestview(save)
end

local has_value = function(tbl, val)
  for _, v in ipairs(tbl) do
    if v == val then
      return true
    end
  end
  return false
end

function trimmer.enable(is_configured)
  local opts = { pattern = '*' }
  local config = require('trim.config').get()
  vim.api.nvim_create_augroup('TrimNvim', { clear = true })
  vim.api.nvim_create_autocmd('BufWritePre', {
    group = 'TrimNvim',
    pattern = opts.pattern,
    callback = function()
      if not has_value(config.ft_blocklist, vim.bo.filetype) then
        trimmer.trim()
      end
    end,
  })
  if not is_configured then
    vim.notify('TrimNvim enabled', vim.log.levels.INFO, { title = 'trim.nvim' })
  end
end

function trimmer.disable()
  pcall(vim.api.nvim_del_augroup_by_name, 'TrimNvim')
  vim.notify('TrimNvim disabled', vim.log.levels.INFO, { title = 'trim.nvim' })
end

function trimmer.toggle()
  local status = pcall(vim.api.nvim_get_autocmds, {
    group = 'TrimNvim',
    event = 'BufWritePre',
  })
  if not status then
    trimmer.enable(false)
  else
    trimmer.disable()
  end
end

return trimmer
