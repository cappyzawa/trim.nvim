if !has('nvim-0.5')
  echoerr "Trim.nvim requires at least nvim-0.5. Please update or uninstall this plugin."
end

if exists('g:loaded_trim_nvim')
  finish
endif
let g:loaded_trim_nvim = 1

command! -nargs=* Trim lua require'trim.trimmer'.trim()
