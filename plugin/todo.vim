if exists("g:todo_vim_loaded")
  finish
endif
let g:todo_vim_loaded = 1

if !exists("g:todo_vim_file_path")
  let g:todo_vim_file_path = '~/todo'
endif
let s:path = fnamemodify(g:todo_vim_file_path, ':p')

" States to support
" - todo buffer not open
" - todo buffer open, visible & saved
" - todo buffer open, visible & changed
" - todo buffer open, hidden & saved
" - todo buffer open, hidden & changed

" returns true if there's no buffer for the todo-file or the buffer has no
" saved changes (ie if it's safe for us to write directly to the file)
function! s:issafetowrite()
  let bufnum = bufnr(s:path)
  return (bufnum ==# -1) || (! getbufvar(bufnum, "&modified"))
endfunction

function! s:refreshcurrentbuffer()
  e
  call feedkeys('<CR>')
endfunction

function! s:refreshotherbuffer()
  let oldbufnum = bufnr('%')
  let oldautoread = &autoread
  set autoread
  execute 'b '.bufnr(s:path)
  let &autoread = oldautoread
  execute 'b '.oldbufnum
endfunction

function! s:refreshbuffer()
  let todobufnum = bufnr(s:path)
  if (todobufnum ==# bufnr('%'))
    call s:refreshcurrentbuffer()
  elseif (todobufnum !=# -1)
    call s:refreshotherbuffer()
  endif
endfunction

function! s:additemtofile(item)
  let lines = readfile(s:path)
  if filewritable(s:path)
    call writefile(add(lines, a:item), s:path)
    call s:refreshbuffer()
  endif
endfunction

function! s:additemtobuffer(item)
  let oldbufnum = bufnr('%')
  execute 'b '.bufnr(s:path)
  call append('$', a:item)
  execute 'b '.oldbufnum
endfunction

" Add a todo item to the todo file.
" this checks whether the file is open with unsaved changes to see if it's
" safe to write directly to the file and if it's not safe, it appends the item
" to the unsaved buffer instead.
function! s:additem(text)
  let item = '[ ] '.a:text
  if s:issafetowrite()
    call s:additemtofile(item)
  else
    call s:additemtobuffer(item)
  endif
endfunction

function! s:command(string)
  if len(a:string) ==# 0
    execute "e ".g:todo_vim_file_path
  else
    call s:additem(a:string)
  endif
endfunction

command! -nargs=* Todo call <SID>command("<args>")
