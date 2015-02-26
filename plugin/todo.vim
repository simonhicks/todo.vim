if exists("g:todo_vim_loaded")
  finish
endif
let g:todo_vim_loaded = 1

if !exists("g:todo_vim_files")
  let g:todo_vim_files = { 'Todo': '~/todo' }
endif

" TODO
" States to support
" - todo buffer not open
" - todo buffer open, visible & saved
" - todo buffer open, visible & changed
" - todo buffer open, hidden & saved
" - todo buffer open, hidden & changed

" returns true if there's no buffer for the todo-file or the buffer has no
" saved changes (ie if it's safe for us to write directly to the file)
function! s:issafetowrite(path)
  let bufnum = bufnr(a:path)
  return (bufnum ==# -1) || (! getbufvar(bufnum, "&modified"))
endfunction

function! s:refreshcurrentbuffer()
  e
  call feedkeys('<CR>')
endfunction

function! s:refreshotherbuffer(path)
  let oldbufnum = bufnr('%')
  let oldautoread = &autoread
  set autoread
  execute 'b '.bufnr(a:path)
  let &autoread = oldautoread
  execute 'b '.oldbufnum
endfunction

function! s:refreshbuffer(path)
  let todobufnum = bufnr(a:path)
  if (todobufnum ==# bufnr('%'))
    call s:refreshcurrentbuffer()
  elseif (todobufnum !=# -1)
    call s:refreshotherbuffer(a:path)
  endif
endfunction

function! s:appendlinestofile(path, lines)
  let lines = readfile(a:path)
  if filewritable(a:path)
    call writefile(extend(lines, a:lines), a:path)
    call s:refreshbuffer(a:path)
  endif
endfunction

function! s:appendlinestobuffer(path, lines)
  let oldbufnum = bufnr('%')
  execute 'b '.bufnr(a:path)
  call append('$', a:lines)
  execute 'b '.oldbufnum
endfunction

" this checks whether the file is open with unsaved changes to see if it's
" safe to write directly to the file and if it's not safe, it appends the line
" to the unsaved buffer instead.
function! s:appendlinessafely(path, lines)
  if s:issafetowrite(a:path)
    call s:appendlinestofile(a:path, a:lines)
  else
    call s:appendlinestobuffer(a:path, a:lines)
  endif
endfunction

function! s:additem(path, text)
  let item = '[ ] '.a:text
  call s:appendlinessafely(a:path, [item])
endfunction

function! s:moveto(path, start, end)
  let rega = @a
  try
    execute a:start . "," . a:end . "d a"
    let lines = split(@a, "\n")
    call s:appendlinessafely(a:path, lines)
  finally
    let @a = rega
  endtry
endfunction

function! s:command(path, start, end, count, string)
  if len(a:string) ># 0
    call s:additem(a:path, a:string)
  elseif (a:count !=# -1)
    call s:moveto(a:path, a:start, a:end)
  else
    execute "e " . a:path
  endif
endfunction

function! s:initializetodo()
  for name in keys(g:todo_vim_files)
    let path = fnamemodify(g:todo_vim_files[name], ':p')
    if !filereadable(path)
      call system("touch '" . path . "'")
    endif
    execute "command! -range -nargs=* " . name . " call <SID>command('" . path . "', <line1>, <line2>, <count>, '<args>')"
  endfor
endfunction

call s:initializetodo()
