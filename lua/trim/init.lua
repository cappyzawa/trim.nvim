local vim = vim

local M = {
  setup = function ()
    vim.api.nvim_command('command! -nargs=? -range=% -bang Trim lua require"trim.trimmer".trim(<q-args>, <line1>, <line2>)')
  end
}

return M
