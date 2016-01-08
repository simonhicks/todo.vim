if exists("g:loaded_todo_vim_autoload")
  finish
endif
let g:loaded_todo_vim_autoload = 1

function! s:beforesubstitute(line)
  let state = {}
  let state['gdefault'] = &gdefault
  let state['position'] = getpos('.')
  set nogdefault
  exec "normal! ".line(a:line)."gg"
  return state
endfunction

function! s:aftersubstitute(state)
  if a:state['gdefault']
    set gdefault
  endif
  call setpos('.', a:state['position'])
  redraw!
endfunction

function! s:getchar(state)
  return a:state == 1 ? 'X' : ' '
endfunction

function! s:togglestate(state)
  return a:state == 1 ? 0 : (a:state == 0 ? 1 : -1)
endfunction

function! s:setstate(line, new_state)
  let state = s:beforesubstitute(a:line)
  exec "norm! ^lr".s:getchar(a:new_state)
  call s:aftersubstitute(state)
endfunction

function! s:getstate(line)
  let l = getline(a:line)
  if match(l, '^\s*\[\(.\)\]') != -1
    return matchlist(l, '^\s*\[\(.\)\]')[1] ==# 'X'
  else
    return -1
  endif
endfunction

function! todo#toggle(line)
  let new_state = s:togglestate(s:getstate(a:line))
  call s:setstate(a:line, new_state)
endfunction

function! todo#uncheck(line)
  if s:getstate(a:line) == 1
    call todo#toggle(a:line)
  endif
endfunction

function! todo#check(line)
  if s:getstate(a:line) == 0
    call todo#toggle(a:line)
  endif
endfunction
