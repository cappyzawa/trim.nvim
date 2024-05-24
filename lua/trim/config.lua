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
  trim_changed_only = false,
  highlight = false,
  highlight_bg = '#ff0000',
  highlight_ctermbg = 'red',
}

function M.setup(opts)
  opts = opts or {}

  -- compatability: disable -> ft_blocklist
  if opts.disable and not opts.ft_blocklist then
    vim.notify('`disable` is deprecated, use `ft_blocklist` instead', vim.log.levels.WARN, { title = 'trim.nvim' })
    opts.ft_blocklist = opts.disable
  end

  if opts.trim_changed_only and vim.fn.executable('diff') == 0 then
    vim.notify('`trim_changed_only` cannot function without a `diff` binary available in PATH. Disabling trimming.', { title = 'trim.nvim' })
    opts.trim_first_line = false
    opts.trim_last_line = false
    opts.trim_trailing = false
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
    local augroup = vim.api.nvim_create_augroup('TrimHighlight', { clear = true })

    -- Define the autocommand for FileType events
    vim.api.nvim_create_autocmd('FileType', {
      group = augroup,
      pattern = '*', -- This will trigger the autocmd for all file types
      callback = function()
        -- Check if the current file type is not in the blocklist to avoid highlighting
        if not vim.tbl_contains(M.config.ft_blocklist, vim.bo.filetype) then
          -- Apply highlighting for trailing whitespace
          vim.api.nvim_set_hl(0, 'ExtraWhitespace', {
            bg = M.config.highlight_bg,
            ctermbg = M.config.highlight_ctermbg
          })
          vim.api.nvim_exec('match ExtraWhitespace /\\s\\+$/', false)
        else
          -- Clear the highlighting for this buffer if the file type is in the blocklist
          vim.api.nvim_exec('match none', false)
        end
      end,
    })
  end
end

function M.get()
  return M.config
end

return M
