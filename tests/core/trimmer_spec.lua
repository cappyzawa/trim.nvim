local trimmer = require 'trim.trimmer'
local config = require 'trim.config'

local assert = require 'luassert'

describe('trimmer.trim', function()
  before_each(function()
    config.setup()
  end)

  it('trims trailing whitespace from entire buffer when no range specified', function()
    vim.cmd 'new'
    vim.api.nvim_buf_set_lines(0, 0, -1, false, {
      'line1   ',
      'line2  ',
      'line3',
    })

    trimmer.trim()

    local lines = vim.api.nvim_buf_get_lines(0, 0, -1, false)
    assert.are.equal('line1', lines[1])
    assert.are.equal('line2', lines[2])
    assert.are.equal('line3', lines[3])
    vim.cmd 'bdelete!'
  end)

  it('trims trailing whitespace only in specified range', function()
    vim.cmd 'new'
    vim.api.nvim_buf_set_lines(0, 0, -1, false, {
      'line1   ',
      'line2  ',
      'line3   ',
      'line4  ',
    })

    -- only trim lines 2-3
    trimmer.trim(2, 2, 3)

    local lines = vim.api.nvim_buf_get_lines(0, 0, -1, false)
    assert.are.equal('line1   ', lines[1]) -- untouched
    assert.are.equal('line2', lines[2]) -- trimmed
    assert.are.equal('line3', lines[3]) -- trimmed
    assert.are.equal('line4  ', lines[4]) -- untouched
    vim.cmd 'bdelete!'
  end)

  it('does not apply first_line and last_line patterns when range specified', function()
    vim.cmd 'new'
    vim.api.nvim_buf_set_lines(0, 0, -1, false, {
      '',
      'line1   ',
      'line2  ',
      '',
    })

    -- range specified: should only trim trailing whitespace
    trimmer.trim(2, 2, 3)

    local lines = vim.api.nvim_buf_get_lines(0, 0, -1, false)
    assert.are.equal('', lines[1]) -- first empty line preserved
    assert.are.equal('line1', lines[2]) -- trimmed
    assert.are.equal('line2', lines[3]) -- trimmed
    assert.are.equal('', lines[4]) -- last empty line preserved
    vim.cmd 'bdelete!'
  end)
end)
