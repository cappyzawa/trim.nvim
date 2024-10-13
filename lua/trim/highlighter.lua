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

function highlighter.highlight()
  vim.api.nvim_exec2('match none', { output = false })
  if has_value(config.ft_blocklist, vim.bo.filetype) then
    return
  end
  if not highlighter.is_pending then
    highlighter.is_pending = true
    vim.defer_fn(function()
      vim.api.nvim_set_hl(0, 'ExtraWhitespace', {
        bg = config.highlight_bg,
        ctermbg = config.highlight_ctermbg,
      })
      vim.api.nvim_exec2('match ExtraWhitespace /\\s\\+$/', { output = false })
      highlighter.is_pending = false
    end, 1000)
  end
end

return highlighter
