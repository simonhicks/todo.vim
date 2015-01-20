if exists("g:todo_vim_loaded")
  finish
endif
let g:todo_vim_loaded = 1

if !exists("g:todo_vim_file_path")
  let g:todo_vim_file_path = '~/todo'
endif

function! s:iswritable(path)
  let bufnum = bufnr(a:path)
  return (bufnum ==# -1) || (! getbufvar(bufnum, "&modified"))
endfunction

function! s:refreshbuffer(path)
  let bufnum = bufnr(a:path)
  if (bufnum !=# -1)
    let oldbufnum = bufnr('%')
    let oldautoread = &autoread
    set autoread
    execute 'b '.bufnr(a:path)
    let &autoread = oldautoread
    execute 'b '.oldbufnum
  endif
endfunction

function! s:additemtofile(path, item)
  let lines = readfile(a:path)
  if filewritable(a:path)
    call writefile(add(lines, a:item), a:path)
    call s:refreshbuffer(a:path)
  endif
endfunction

function! s:additemtobuffer(path, item)
  let oldbufnum = bufnr('%')
  execute 'b '.bufnr(a:path)
  call append('$', a:item)
  execute 'b '.oldbufnum
endfunction

" Add a todo item to the todo file.
" this checks whether the file is open with unsaved changes to see if it's
" safe to write directly to the file and if it's not safe, it appends the item
" to the unsaved buffer instead.
function! s:additem(file, text)
  let path = fnamemodify(a:file, ':p')
  let item = '[ ] '.a:text
  if s:iswritable(path)
    call s:additemtofile(path, item)
  else
    call s:additemtobuffer(path, item)
  endif
endfunction

function! s:command(...)
  if len(a:000) ==# 0
    e g:todo_vim_file_path
  else
    call s:additem(g:todo_vim_file_path, a:1)
  endif
endfunction

command! -nargs=+ Todo call <SID>command("<args>")
