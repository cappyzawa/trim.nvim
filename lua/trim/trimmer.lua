local vim = vim
local api = vim.api
local trimmer = {
  trim = function (arg, startLine, endLine)
    startLine = startLine - 1
    local bufnr = api.nvim_get_current_buf()
    local win = api.nvim_get_current_win()
    local pos = api.nvim_win_get_cursor(win)
    local lines = api.nvim_buf_get_lines(bufnr, startLine, endLine, true)
    local newLines = {}
    local endIndex = #lines
    while endIndex > 0 do
      if lines[endIndex] == "" then
        endIndex = endIndex - 1
      else
        break
      end
    end
    for i=1, endIndex, 1 do
      local newLine = string.gsub(lines[i], "%s+$", "")
      table.insert(newLines, newLine)
    end
    api.nvim_buf_set_lines(bufnr, startLine, endLine, true, newLines)
    if pos[1] >= #newLines then pos[1] = #newLines end
    api.nvim_win_set_cursor(win, pos)
  end
}

return trimmer
