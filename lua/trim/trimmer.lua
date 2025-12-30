local vim = vim
local api = vim.api

local trimmer = {}

function trimmer.trim(range, line1, line2)
  local config = require('trim.config').get()
  local save = vim.fn.winsaveview()

  if range and range > 0 then
    -- range specified: only trim trailing whitespace in the given range
    local cmd = string.format('keepjumps keeppatterns silent! %d,%ds/\\s\\+$//e', line1, line2)
    api.nvim_exec2(cmd, {})
  else
    -- trim_trailing with cursor line exclusion
    if config.trim_trailing and not config.trim_current_line then
      local lnum = vim.api.nvim_win_get_cursor(0)[1]
      local last = vim.api.nvim_buf_line_count(0)

      -- trim lines above cursor
      if lnum > 1 then
        local cmd = string.format('keepjumps keeppatterns silent! 1,%ds/\\s\\+$//e', lnum - 1)
        api.nvim_exec2(cmd, {})
      end
      -- trim lines below cursor
      if lnum < last then
        local cmd = string.format('keepjumps keeppatterns silent! %d,$s/\\s\\+$//e', lnum + 1)
        api.nvim_exec2(cmd, {})
      end
    end

    -- apply other patterns (trim_first_line, trim_last_line, custom patterns)
    for _, v in ipairs(config.patterns) do
      api.nvim_exec2(string.format('keepjumps keeppatterns silent! %s', v), {})
    end
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
  if config.notifications and not is_configured then
    vim.notify('TrimNvim enabled', vim.log.levels.INFO, { title = 'trim.nvim' })
  end
end

function trimmer.disable()
  pcall(vim.api.nvim_del_augroup_by_name, 'TrimNvim')
  if require('trim.config').get().notifications then
    vim.notify('TrimNvim disabled', vim.log.levels.INFO, { title = 'trim.nvim' })
  end
end

function trimmer.is_enabled()
  local status = pcall(vim.api.nvim_get_autocmds, {
    group = 'TrimNvim',
    event = 'BufWritePre',
  })
  if not status then
    return false
  end
  return true
end

function trimmer.toggle()
  if not trimmer.is_enabled() then
    trimmer.enable(false)
  else
    trimmer.disable()
  end
end

return trimmer
