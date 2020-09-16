local vim = vim
local api = vim.api
local trimmer = {
  trim = function (arg, startLine, endLine)
    startLine = startLine - 1
    local bufnr = api.nvim_get_current_buf()
    local lines = api.nvim_buf_get_lines(bufnr, startLine, endLine, true)
    local newLines = {}
    for _, v in ipairs(lines) do
      local newLine = string.gsub(v, "%s+$", "")
      table.insert(newLines, newLine)
    end
    api.nvim_buf_set_lines(bufnr, startLine, endLine, true, newLines)
  end
}

return trimmer
