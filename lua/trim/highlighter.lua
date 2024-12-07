local config = require('trim.config').get()

local highlighter = {
  is_pending = false,
}

local has_value = function(tbl, val)
  for _, v in ipairs(tbl) do
    if v == val then
      return true
    end
  end
  return false
end

local function add_whitespace_matches()
  if vim.w.trim_whitespace_match_ids == nil then
    vim.w.trim_whitespace_match_ids = {
      -- Trailing whitespaces
      vim.fn.matchadd('ExtraWhitespace', '\\s\\+$'),
      -- Trailing empty lines
      vim.fn.matchadd('ExtraWhitespace', '^\\_s*\\%$'),
    }
  end
end

local function add_cursor_matches()
  if vim.w.trim_cursor_match_ids == nil then
    vim.w.trim_cursor_match_ids = {
      -- no highlight for whitespaces before cursor position
      vim.fn.matchadd('Conceal', '\\s\\+\\%#'),
      -- no highlight for lines before cursor line
      vim.fn.matchadd('Conceal', '^\\_s*\\%#'),
    }
  end
end

local function delete_whitespace_matches()
  for _, matchid in ipairs(vim.w.trim_whitespace_match_ids or {}) do
    vim.fn.matchdelete(matchid)
  end
  vim.w.trim_whitespace_match_ids = nil
end

local function delete_cursor_matches()
  for _, matchid in ipairs(vim.w.trim_cursor_match_ids or {}) do
    vim.fn.matchdelete(matchid)
  end
  vim.w.trim_cursor_match_ids = nil
end

function highlighter.setup()
  vim.api.nvim_set_hl(0, 'ExtraWhitespace', {
    bg = config.highlight_bg,
    ctermbg = config.highlight_ctermbg,
  })

  local augroup = vim.api.nvim_create_augroup('TrimHighlight', { clear = true })
  vim.api.nvim_create_autocmd({ 'BufEnter', 'WinEnter', 'TermEnter' }, {
    group = augroup,
    callback = function()
      if vim.bo.buftype == '' and not has_value(config.ft_blocklist, vim.bo.filetype) then
        add_whitespace_matches()
        add_cursor_matches()
      else
        delete_whitespace_matches()
        delete_cursor_matches()
      end
    end,
  })

  -- After cursor left window, the matches related to cursor would not work,
  -- so clear them on BufLeave/WinLeave
  vim.api.nvim_create_autocmd({ 'BufLeave', 'WinLeave', 'TermLeave' }, {
    group = augroup,
    callback = function()
      delete_cursor_matches()
    end,
  })
end

return highlighter
