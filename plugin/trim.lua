if vim.g.load_trim_nvim then
  return
end
vim.g.load_trim_nvim = true

if not vim.api.nvim_create_autocmd then
  vim.notify_once('trim.nvim requires nvim 0.7.0+.', vim.log.levels.ERROR, { title = 'trim.nvim' })
  return
end

vim.api.nvim_create_user_command('TrimToggle', function(args)
  require('trim').toggle()
end, {
  range = false,
})

vim.api.nvim_create_user_command('Trim', function(args)
  require('trim').trim()
end, {
  range = false,
})
