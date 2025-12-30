local M = {
  config = {},
}

local default_config = {
  ft_blocklist = {},
  patterns = {},
  trim_on_write = true,
  trim_trailing = true,
  trim_last_line = true,
  trim_first_line = true,
  trim_current_line = true,
  highlight = false,
  highlight_bg = '#ff0000',
  highlight_ctermbg = 'red',
  notifications = true,
}

function M.setup(opts)
  opts = opts or {}

  -- compatability: disable -> ft_blocklist
  if opts.disable and not opts.ft_blocklist then
    vim.notify('`disable` is deprecated, use `ft_blocklist` instead', vim.log.levels.WARN, { title = 'trim.nvim' })
    opts.ft_blocklist = opts.disable
  end

  M.config = vim.tbl_deep_extend('force', default_config, opts)

  -- preserve user-specified patterns, reset if not specified
  local user_patterns = opts.patterns or {}
  M.config.patterns = {}
  for _, p in ipairs(user_patterns) do
    table.insert(M.config.patterns, p)
  end

  if M.config.trim_trailing and M.config.trim_current_line then
    table.insert(M.config.patterns, [[%s/\s\+$//e]])
  end
  if M.config.trim_first_line then
    table.insert(M.config.patterns, [[%s/\%^\n\+//]])
  end
  if M.config.trim_last_line then
    table.insert(M.config.patterns, [[%s/\($\n\s*\)\+\%$//]])
  end

  if M.config.highlight then
    require("trim.highlighter").setup()
  end
end

function M.get()
  return M.config
end

return M
