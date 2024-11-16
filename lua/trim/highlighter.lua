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

function highlighter.setup()
  vim.api.nvim_set_hl(0, 'ExtraWhitespace', {
    bg = config.highlight_bg,
    ctermbg = config.highlight_ctermbg,
  })

  local augroup = vim.api.nvim_create_augroup('TrimHighlight', { clear = true })
  vim.api.nvim_create_autocmd('FileType', {
    group = augroup,
    pattern = '*',
    callback = function()
      if vim.bo.buftype == '' and not has_value(config.ft_blocklist, vim.bo.filetype) then
        -- Trailing whitespaces
        vim.fn.matchadd('ExtraWhitespace', '\\s\\+$')
        -- no highlight for whitespaces before cursor position
        vim.fn.matchadd('Conceal', '\\s\\+\\%#')

        -- Trailing empty lines
        vim.fn.matchadd('ExtraWhitespace', '^\\_s*\\%$')
        -- no highlight for lines before cursor line
        vim.fn.matchadd('Conceal', '^\\_s*\\%#')
      end
    end,
  })
end

return highlighter
