" @Author:      Tom Link (mailto:micathom AT gmail com?subject=[vim])
" @License:     GPL (see http://www.gnu.org/licenses/gpl.txt)
" @Created:     2012-09-09.
" @Last Change: 2012-09-09.
" @Revision:    3


" :nodoc:
function! tinykeymap#buffers#Buffer(...) "{{{3
    if a:0 >= 1
        let nr = a:1
    else
        let buflist = s:List(g:tinykeymap#buffers#idx, 1, g:tinykeymap#buffers#filter)
        let nr = matchstr(get(buflist, 0, ''), '^\d\+')
    endif
    if !empty(nr)
        exec 'buffer' nr
    endif
endf


" :nodoc:
function! tinykeymap#buffers#Shift(n) "{{{3
    let buflist = s:List(1, 0, "")
    let max = len(buflist)
    " TLogVAR g:tinykeymap#buffers#idx, a:n, max, buflist
    let g:tinykeymap#buffers#idx = (g:tinykeymap#buffers#idx + a:n) % max
    if g:tinykeymap#buffers#idx <= 0
        let g:tinykeymap#buffers#idx = max + g:tinykeymap#buffers#idx
    endif
    " TLogVAR g:tinykeymap#buffers#idx
endf


function! s:List(start_idx, rotate, filter) "{{{3
    let buffers = []
    let cur_idx = -1
    for i in range(1, bufnr('$'))
        if buflisted(i) && bufloaded(i)
            " let bufname = fnamemodify(bufname(i), ':t')
            let bufname = bufname(i)
            let desc = printf('%s %s', i, pathshorten(bufname))
            if i == bufnr('%')
                let cur_idx = len(buffers)
            endif
            call add(buffers, desc)
        endif
    endfor
    if len(buffers) > 1
        if cur_idx > 0
            let buffers = buffers[cur_idx : -1] + buffers[0 : cur_idx - 1]
        endif
        if !empty(a:filter)
            let buffers = filter(copy(buffers), 'v:val =~ a:filter') + 
                        \ filter(copy(buffers), 'v:val !~ a:filter')
        endif
        if a:start_idx > 1
            let start_idx = a:start_idx - 1
            let buffers = buffers[start_idx : -1] + buffers[0 : start_idx - 1]
        endif
    endif
    " TLogVAR a:start_idx, buffers
    return buffers
endf


" :nodoc:
function! tinykeymap#buffers#List(start_idx) "{{{3
    return join(s:List(a:start_idx, 1, g:tinykeymap#buffers#filter), ', ')
endf

