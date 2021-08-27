local vim = vim
local config = require'trim.config'

local M = {}

M.setup = function(cfg)
  if cfg.disable then
    config.disable = cfg.disable
  end

  if cfg.patterns then
    config.patterns = cfg.patterns
  end

  vim.cmd [[augroup TrimNvim]]
  vim.cmd [[  autocmd!]]
  if not cfg.disable then
    vim.cmd [[ autocmd BufWritePre * Trim]]
  else
    for _, v in pairs(config.disable) do
      vim.cmd (string.format("  autocmd BufWritePre * if &filetype != '%s' | Trim", v))
    end
  end
  vim.cmd [[augroup END]]
end

return M
