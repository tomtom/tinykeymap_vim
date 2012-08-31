" buffers.vim
" @Author:      Tom Link (mailto:micathom AT gmail com?subject=[vim])
" @License:     GPL (see http://www.gnu.org/licenses/gpl.txt)
" @Created:     2012-08-28.
" @Last Change: 2012-08-31.
" @Revision:    102

if !exists('g:tinykeymap#buffers#map')
    " Map leader for the "buffers" tinykeymap.
    let g:tinykeymap#buffers#map = g:mapleader ."b"   "{{{2
endif


call tinykeymap#EnterMap("buffers", g:tinykeymap#buffers#map, {
            \ 'message': 'tinykeymap#buffers#List(g:tinykeymap#buffers#idx)',
            \ 'start': 'let g:tinykeymap#buffers#idx = 1 | let g:tinykeymap#buffers#filter = ""',
            \ })
call tinykeymap#Map('buffers', '<CR>', 'call tinykeymap#buffers#Buffer(<count>)', {'exit': 1})
call tinykeymap#Map('buffers', 'd', 'drop <count>', {'exit': 1})
call tinykeymap#Map('buffers', 'b', 'buffer <count>')
call tinykeymap#Map('buffers', 's', 'sbuffer <count>')
call tinykeymap#Map('buffers', 'v', 'vert sbuffer <count>')
call tinykeymap#Map('buffers', 'n', 'bnext <count>')
call tinykeymap#Map('buffers', 'p', 'bprevious <count>')
call tinykeymap#Map('buffers', '<Down>', 'bnext <count>')
call tinykeymap#Map('buffers', '<Up>', 'bprevious <count>')
call tinykeymap#Map('buffers', '<Home>', 'bfirst')
call tinykeymap#Map('buffers', '<End>', 'blast')
call tinykeymap#Map('buffers', '<Space>', 'ls! | call tinykeymap#PressEnter()')
call tinykeymap#Map('buffers', 'D', 'bdelete <count>')
call tinykeymap#Map('buffers', '<Left>', 'call tinykeymap#buffers#Shift(-<count1>)',
            \ {'desc': 'Rotate list to the right'})
call tinykeymap#Map('buffers', '<Right>', 'call tinykeymap#buffers#Shift(<count1>)',
            \ {'desc': 'Rotate list to the left'})
call tinykeymap#Map('buffers', '/', 'let g:tinykeymap#buffers#filter = input("Filter regexp: ")',
            \ {'desc': 'Prioritize buffers matching a regexp'})


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
    return "buffers: ". join(s:List(a:start_idx, 1, g:tinykeymap#buffers#filter), ', ')
endf

