-- Minimal config for development and manual testing
-- Usage: nvim --clean -u dev/init.lua [file]

local root = vim.fn.fnamemodify(debug.getinfo(1, 'S').source:sub(2), ':p:h:h')

-- Setup runtimepath
vim.opt.runtimepath:prepend(root)
vim.opt.runtimepath:append(root .. '/after')

-- Basic settings
vim.opt.termguicolors = true
vim.opt.number = true
vim.opt.list = true
vim.opt.listchars = { tab = '» ', trail = '·', nbsp = '␣' }

-- Setup trim.nvim with highlight enabled for easier testing
require('trim').setup({
  ft_blocklist = { 'markdown' },
  highlight = true,
  highlight_bg = '#ff0000',
})

-- Create sample file with trailing whitespace for testing :w behavior
local sample_file = root .. '/dev/sample.txt'
local sample_content = {
  'Line with trailing spaces   ',
  '',
  'Normal line',
  'Another line with tabs\t\t',
  '',
  '',
}

local function create_sample()
  local f = io.open(sample_file, 'w')
  if f then
    f:write(table.concat(sample_content, '\n'))
    f:close()
  end
end

-- If no file argument provided, create and open sample file
if vim.fn.argc() == 0 then
  create_sample()
  vim.cmd.edit(sample_file)
end
