local vim = vim
local M = {}

function M.setup(o)
  vim.cmd [=[command! -nargs=? -range=% -bang Trim lua require"trim.trimmer".trim(<q-args>, <line1>, <line2>)]=]

  setAutocmd(o)
end

function setAutocmd(o)
  local config = require("trim.config")
  local disable = o.disable
  if #disable == 0 then disable = config.default_disable end
  local excepts = {}
  for _, v in pairs(disable) do
    table.insert(excepts, string.format("&filetype != '%s'", v))
  end
  vim.cmd [=[augroup TrimNvim]=]
  vim.cmd [=[  autocmd!]=]
  vim.cmd (string.format("  autocmd BufWritePre * if %s | Trim | endif", table.concat(excepts, " && ")))
  vim.cmd [=[augroup END]=]
end

return M
