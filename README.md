# trim.nvim

[![GitHub release](https://img.shields.io/github/release/cappyzawa/trim.nvim.svg)](https://github.com/cappyzawa/trim.nvim/releases)
[![GitHub](https://img.shields.io/github/license/cappyzawa/trim.nvim.svg)](./LICENSE)

This plugin trims trailing whitespace and lines.

## Requirements

**Neovim v0.7.0+**

## How to install

### Lazy

```lua
require("lazy").setup({
  "cappyzawa/trim.nvim",
  opts = {}
}, opt)
```

### Packer

```lua
use({
  "cappyzawa/trim.nvim",
  config = function()
    require("trim").setup({})
  end
})
```

## How to setup

```lua
-- default config
local default_config = {
  ft_blocklist = {},
  patterns = {},
  trim_on_write = true,
  trim_trailing = true,
  trim_last_line = true,
  trim_first_line = true,
  highlight = false,
  highlight_bg = '#ff0000', -- or 'red'
  highlight_ctermbg = 'red',
}
```

```lua
require('trim').setup({
  -- if you want to ignore markdown file.
  -- you can specify filetypes.
  ft_blocklist = {"markdown"},

  -- if you want to remove multiple blank lines
  patterns = {
    [[%s/\(\n\n\)\n\+/\1/]],   -- replace multiple blank lines with a single line
  },

  -- if you want to disable trim on write by default
  trim_on_write = false,

  -- highlight trailing spaces
  highlight = true
})
```

## Commands

### `:TrimToggle`

Toggle trim on save.

### `:Trim`

Trim the buffer right away.
