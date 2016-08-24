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

function! s:toggleboolean(bool)
  return a:bool == 1 ? 0 : (a:bool == 0 ? 1 : -1)
endfunction

" functions for state

let s:stateregex = '^\s*\[\(.\)\]'

function! s:getchar(state)
  return a:state == 1 ? 'X' : ' '
endfunction

function! s:setstate(line, new_state)
  let bufferstate = s:beforesubstitute(a:line)
  exec "norm! ^lr".s:getchar(a:new_state)
  call s:aftersubstitute(bufferstate)
endfunction

function! s:getstate(line)
  let l = getline(a:line)
  if match(l, s:stateregex) != -1
    return matchlist(l, s:stateregex)[1] ==# 'X'
  else
    return -1
  endif
endfunction

" functions for priority

let s:priorityregex = '^\s*\[.\] \(.\)'

" TODO this is basically the same as s:getstate... refactor
function! s:getpriority(line)
  let l = getline(a:line)
  if match(l, s:priorityregex) != -1
    return matchlist(l, s:priorityregex)[1] ==# '!'
  else
    return -1
  endif
endfunction

function! s:setpriority(line, new_priority)
  let bufferstate = s:beforesubstitute(a:line)
  if a:new_priority ==# 1
    exec "norm! ^3li !"
  elseif a:new_priority ==# 0
    exec "norm! ^3lxx"
  endif
  call s:aftersubstitute(bufferstate)
endfunction

" exports

function! todo#toggle(line)
  let new_state = s:toggleboolean(s:getstate(a:line))
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

function! todo#togglepriority(line)
  let new_priority = s:toggleboolean(s:getpriority(a:line))
  call s:setpriority(a:line, new_priority)
endfunction

function! todo#lowpriority(line)
  if s:getpriority(a:line) == 1
    call todo#togglepriority(a:line)
  endif
endfunction

function! todo#highpriority(line)
  if s:getpriority(a:line) == 0
    call todo#togglepriority(a:line)
  endif
endfunction
