local vim = vim
local api = vim.api
local trimmer = {
  trim = function (arg, startLine, endLine)
    startLine = startLine - 1
    local bufnr = api.nvim_get_current_buf()
    local lines = api.nvim_buf_get_lines(bufnr, startLine, endLine, true)
    local newLines = {}
    local endIndex = #lines
    while endIndex > 0 and lines[endIndex] == "" do
      endIndex = endIndex - 1
    end
    for i=1, endIndex, 1 do
      local newLine = string.gsub(lines[i], "%s+$", "")
      table.insert(newLines, newLine)
    end
    api.nvim_buf_set_lines(bufnr, startLine, endLine, true, newLines)
  end
}

return trimmer
