# trim.nvim

[![GitHub release](https://img.shields.io/github/release/cappyzawa/trim.nvim.svg)](https://github.com/cappyzawa/trim.nvim/releases)
[![GitHub](https://img.shields.io/github/license/cappyzawa/trim.nvim.svg)](./LICENSE)

This plugin trims trailing whitespace and lines.

## Requirements

**Neovim v0.7.0+**

## How to install

```vim
Plug 'cappyzawa/trim.nvim'
```

## How to setup

```lua
-- default config
local config = {
  disable = {},
  patterns = {},
  trim_trailing = true,
  trim_last_line = true,
  trim_first_line = true,
}
```

```vim
lua <<EOF
  require('trim').setup({
    -- if you want to ignore markdown file.
    -- you can specify filetypes.
    disable = {"markdown"},

    -- if you want to remove multiple blank lines
    patterns = {
      [[%s/\(\n\n\)\n\+/\1/]],   -- replace multiple blank lines with a single line
    },
  })
EOF
```
*If you save **without** formatting, use `:noa w`*
