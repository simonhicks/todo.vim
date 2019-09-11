if exists("b:did_ftplugin")
  finish
endif
let b:did_ftplugin = 1

if !exists("g:todo_vim_no_mappings") || g:todo_vim_no_mappings !=# 0
  nnoremap <buffer> [d :silent call todo#uncheck('.')<CR>
  nnoremap <buffer> ]d :silent call todo#check('.')<CR>
  nnoremap <buffer> [p :silent call todo#lowpriority('.')<CR>
  nnoremap <buffer> ]p :silent call todo#highpriority('.')<CR>
  nnoremap <buffer> [[ :silent call todo#findpriority('.', 'prev')<CR>
  nnoremap <buffer> ]] :silent call todo#findpriority('.', 'next')<CR>
  if has("gui_running")
    nnoremap <buffer> <2-LeftMouse> :silent call todo#toggle('.')<CR>
  endif
endif
