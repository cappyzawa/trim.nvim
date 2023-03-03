local M = {}

local config = require 'trim.config'
local trimmer = require 'trim.trimmer'

function M.setup(opt)
  config.setup(opt)
  local cfg = config.get()
  if cfg.trim_on_write then
    trimmer.enable(true)
  end
end

return M
