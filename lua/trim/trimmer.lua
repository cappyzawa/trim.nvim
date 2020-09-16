local vim = vim
local api = vim.api
local trimmer = {
  trim = function (arg, startLine, endLine)
    print("arg", arg)
    print("start", startLine)
    print("end", endLine)
  end
}

return trimmer
