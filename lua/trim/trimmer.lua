local vim = vim
local api = vim.api

local trimmer = {}

trimmer.trim = function(patterns)
	local save = vim.fn.winsaveview()
	for _, v in ipairs(patterns) do
		api.nvim_exec(string.format("keepjumps keeppatterns silent! %s", v), false)
	end
	vim.fn.winrestview(save)
end

return trimmer
