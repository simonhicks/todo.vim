if exists("b:did_ftplugin")
  finish
endif
let b:did_ftplugin = 1

if !exists("g:todo_vim_no_mappings") || g:todo_vim_no_mappings !=# 0
  nnoremap [d :silent call todo#uncheck('.')<CR>
  nnoremap ]d :silent call todo#check('.')<CR>
endif
