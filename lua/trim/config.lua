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
  highlight = false,
  highlight_bg = 'red',
  highlight_ctermbg = 'red',
}

function M.setup(opts)
  opts = opts or {}

  -- compatability: disable -> ft_blocklist
  if opts.disable and not opts.ft_blocklist then
    vim.notify('`disable` is deprecated, use `ft_blocklist` instead', vim.log.levels.WARN, { title = 'trim.nvim' })
    opts.ft_blocklist = opts.disable
  end

  M.config = vim.tbl_deep_extend('force', default_config, opts)

  if M.config.trim_trailing then
    table.insert(M.config.patterns, [[%s/\s\+$//e]])
  end
  if M.config.trim_first_line then
    table.insert(M.config.patterns, [[%s/\%^\n\+//]])
  end
  if M.config.trim_last_line then
    table.insert(M.config.patterns, [[%s/\($\n\s*\)\+\%$//]])
  end

  if M.config.highlight then
    vim.api.nvim_set_hl(0, "ExtraWhitespace", { bg = M.config.highlight_bg, ctermbg = M.config.highlight_ctermbg })

    vim.api.nvim_exec([[
      match ExtraWhitespace /\s\+$/
    ]], false)
  end
end

function M.get()
  return M.config
end

return M
