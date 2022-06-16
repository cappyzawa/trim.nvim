local config = {
  disable = {},
  patterns = {
    [[%s/\s\+$//e]], [[%s/\($\n\s*\)\+\%$//]], [[%s/\%^\n\+//]],
    [[%s/\(\n\n\)\n\+/\1/]]
  }
}

return config
