if exists("b:did_ftplugin")
  finish
endif
let b:did_ftplugin = 1

nnoremap [d :silent call todo#uncheck('.')<CR>
nnoremap ]d :silent call todo#check('.')<CR>
