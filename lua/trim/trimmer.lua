local vim = vim
local api = vim.api

local trimmer = {}

function trimmer.changed_blocks()
  local filename = vim.api.nvim_buf_get_name(0)

  if vim.fn.filereadable(filename) == 0 then
    return {1, vim.fn.line('$')}
  end

  if vim.bo.modified then
    local diff_bits = {
      "diff",
      "-a",
      "--unchanged-group-format=",
      "--old-group-format=",
      "--new-group-format=%dF,%dL ",
      "--changed-group-format=%dF,%dL ",
      filename,
      "-"
    }

    local format = vim.api.nvim_buf_get_option(0, 'fileformat')
    local line_ending = line_endings[format]

    local file_content = table.concat(vim.api.nvim_buf_get_lines(0, 0, -1, true), line_ending) .. line_ending
    local call_result = vim.system(diff_bits, {stdin = file_content, text = true}):wait()

    local trimmed_output = vim.fn.trim(call_result.stdout)
    local changes_list = vim.split(trimmed_output, ' ')
    local result = vim.tbl_map(function(val)
      return vim.split(val, ',')
    end, changes_list)

    return result
  end

  return {}
end

local format_line_endings = {
  unix = "\n",
  dos = "\r\n",
  mac = "\r",
}

function trimmer.trim()
  local config = require('trim.config').get()
  local save = vim.fn.winsaveview()
  if config.trim_changed_only then
    local line_trailing_pattern = [[s/\s\+$//e]]
    local changed_blocks = trimmer.changed_blocks()

    -- Trim ends of all changed lines
    local num_changed_lines = 0
    for _, range in ipairs(changed_blocks) do
      local command = string.format('keepjumps keeppatterns silent! %s,%s%s', range[1], range[2], line_trailing_pattern)
      api.nvim_exec2(command)
      num_changed_lines = num_changed_lines + 1
    end

    -- NOTE: order is important, do trailing first, then leading, otherwise the
    -- line ranges might not be accurate anymore
    local line_count = vim.api.nvim_buf_line_count(0)
    if config.trim_last_line and num_changed_lines > 0 and changed_blocks[num_changed_lines][2] == line_count then
      -- Last changed range extends to EOF -> We can trim trailing lines
      api.nvim_exec2([[keepjumps keeppatterns silent! %s/\($\n\s*\)\+\%$//]])
    end

    if config.trim_first_line and num_changed_lines > 0 and changed_blocks[1][1] == 1 then
      -- First changed range starts at first line -> We can trim leading lines
      api.nvim_exec2([[keepjumps keeppatterns silent! %s/\%^\n\+//]])
    end
  else
    -- Trim globally
    for _, v in ipairs(config.patterns) do
      api.nvim_exec2(string.format('keepjumps keeppatterns silent! %s', v), false)
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
