local vim = vim
local trimmer = require 'trim.trimmer'

local default_config = {
  ft_blocklist = {},
  patterns = {},
  trim_on_write = true,
  trim_trailing = true,
  trim_last_line = true,
  trim_first_line = true,
}

local M = {
  config = {},
}

local has_value = function(tbl, val)
  for _, v in ipairs(tbl) do
    if v == val then
      return true
    end
  end
  return false
end

function M.setup(opts)
  opts = opts or {}

  -- compatability: disable -> ft_blocklist
  if opts.disable and not opts.ft_blocklist then
    vim.notify('`disable` is deprecated, use `ft_blocklist` instead', vim.log.levels.WARN, { title = 'trim.nvim' })
    opts.ft_blocklist = opts.disable
  end

  M.config = vim.tbl_deep_extend('force', default_config, opts)

  if M.config.trim_first_line then
    table.insert(M.config.patterns, [[%s/\%^\n\+//]])
  end
  if M.config.trim_last_line then
    table.insert(M.config.patterns, [[%s/\($\n\s*\)\+\%$//]])
  end
  if M.config.trim_trailing then
    table.insert(M.config.patterns, 1, [[%s/\s\+$//e]])
  end

  if M.config.trim_on_write then
    M.enable(true)
  end
end

function M.toggle()
  local status = pcall(vim.api.nvim_get_autocmds, {
    group = 'TrimNvim',
    event = 'BufWritePre',
  })
  if not status then
    M.enable(false)
  else
    M.disable()
  end
end

function M.enable(is_configured)
  local opts = { pattern = '*' }
  vim.api.nvim_create_augroup('TrimNvim', { clear = true })
  vim.api.nvim_create_autocmd('BufWritePre', {
    group = 'TrimNvim',
    pattern = opts.pattern,
    callback = function()
      if not has_value(M.config.ft_blocklist, vim.bo.filetype) then
        M.trim()
      end
    end,
  })
  if not is_configured then
    vim.notify('TrimNvim enabled', vim.log.levels.INFO, { title = 'trim.nvim' })
  end
end

function M.disable()
  pcall(vim.api.nvim_del_augroup_by_name, 'TrimNvim')
  vim.notify('TrimNvim disabled', vim.log.levels.INFO, { title = 'trim.nvim' })
end

function M.trim()
  trimmer.trim(M.config.patterns)
end

return M
