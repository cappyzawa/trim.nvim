local config = require 'trim.config'

local assert = require 'luassert'

describe('default config', function()
  config.setup()
  local actual = config.get()

  it('has empty ft_blocklist', function()
    assert.are.equal(#actual.ft_blocklist, 0)
  end)

  it('has trim_on_write enabled', function()
    assert.is_true(actual.trim_on_write)
  end)

  it('has trim_trailing enabled', function()
    assert.is_true(actual.trim_trailing)
  end)

  it('has trim_last_line enabled', function()
    assert.is_true(actual.trim_last_line)
  end)

  it('has trim_first_line enabled', function()
    assert.is_true(actual.trim_first_line)
  end)

  it('has 3 patterns', function()
    assert.are.equal(#actual.patterns, 3)
    assert.are.equal(actual.patterns[1], [[%s/\s\+$//e]])
    assert.are.equal(actual.patterns[2], [[%s/\%^\n\+//]])
    assert.are.equal(actual.patterns[3], [[%s/\($\n\s*\)\+\%$//]])
  end)
end)

describe('config', function()
  config.setup {
    ft_blocklist = { 'markdown' },
    trim_on_write = false,
    trim_trailing = false,
    trim_last_line = false,
    trim_first_line = false,
    patterns = { [[%s/\(\n\n\)\n\+/\1/]] },
  }

  local actual = config.get()

  it('is overwritten', function()
    assert(#actual.ft_blocklist, 1)
    assert(actual.ft_blocklist[1], 'markdown')
    assert.is_not_true(actual.trim_on_write)
    assert.is_not_true(actual.trim_trailing)
    assert.is_not_true(actual.trim_last_line)
    assert.is_not_true(actual.trim_first_line)

    assert.are.equal(#actual.patterns, 1)
    assert.are.equal(actual.patterns[1], [[%s/\(\n\n\)\n\+/\1/]])
  end)

  it('keeps compatability', function()
    config.setup { disable = { 'lua' } }
    local actual = config.get()

    -- disable is deprecated, use ft_blocklist instead
    assert.are.equal(#actual.ft_blocklist, 1)
    assert.are.equal(actual.ft_blocklist[1], 'lua')
  end)
end)
