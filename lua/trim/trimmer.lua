local vim = vim
local api = vim.api
local trimmer = {
  trim = function (arg, startLine, endLine)
    -- reference: https://vim.fandom.com/wiki/Remove_unwanted_spaces
    api.nvim_exec([[silent! %s/\s\+$//e]], false)
    -- reference: https://stackoverflow.com/questions/7495932/how-can-i-trim-blank-lines-at-the-end-of-file-in-vim
    api.nvim_exec([[silent! %s#\($\n\s*\)\+\%$##]], false)
    api.nvim_exec([[silent! %s/\%^\n\+//]], false)
    -- reference: https://unix.stackexchange.com/questions/12812/replacing-multiple-blank-lines-with-a-single-blank-line-in-vim-sed
    api.nvim_exec([[silent! %s/\(\n\n\)\n\+/\1/]], false)
  end
}

return trimmer
