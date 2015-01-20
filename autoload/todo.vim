if exists("g:loaded_todo_vim_autoload")
  finish
endif
let g:loaded_todo_vim_autoload = 1

function! s:before_substitute(line)
  let state = {}
  let state['register'] = @/
  let state['gdefault'] = &gdefault
  let state['position'] = getpos('.')
  set nogdefault
  exec "normal! ".line(a:line)."gg"
  return state
endfunction

function! s:after_substitute(state)
  if a:state['gdefault']
    set gdefault
  endif
  call setpos('.', a:state['position'])
  let @/ = a:state['register']
  redraw!
endfunction

function! s:substitute(line, pattern, replacement)
  let state = s:before_substitute(a:line)
  if match(getline('.'), a:pattern) != -1
    exec "normal! V:s/".a:pattern."/".a:replacement.""
  endif
  call s:after_substitute(state)
endfunction

function! s:getstate(line)
  let l = getline(a:line)
  echom l
  if match(l, '^\[\(.\)\]') != -1
    return matchlist(l, '^\[\(.\)\]')[1] ==# 'X'
  else
    return -1
  endif
endfunction

function! todo#uncheck(line)
  if s:getstate(a:line) == 1
    call s:substitute(a:line, "\\[X\\]", "[ ]")
  endif
endfunction

function! todo#check(line)
  if s:getstate(a:line) == 0
    call s:substitute(a:line, "\\[ \\]", "[X]")
  endif
endfunction
