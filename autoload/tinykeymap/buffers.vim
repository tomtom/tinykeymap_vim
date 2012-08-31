" buffers.vim
" @Author:      Tom Link (mailto:micathom AT gmail com?subject=[vim])
" @License:     GPL (see http://www.gnu.org/licenses/gpl.txt)
" @Created:     2012-08-28.
" @Last Change: 2012-08-31.
" @Revision:    73

call tinykeymap#EnterMap("buffers", g:mapleader ."b", {
            \ 'message': 'tinykeymap#buffers#List(g:tinykeymap#buffers#idx)',
            \ 'start': 'let g:tinykeymap#buffers#idx = 1 | let g:tinykeymap#buffers#filter = ""',
            \ })
call tinykeymap#Map('buffers', '<CR>', 'buffer <count>', {'exit': 1})
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
            \ {'desc': 'Filter list'})


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
    let prelude = []
    let post = []
    let j = 0
    for i in range(1, bufnr('$'))
        if buflisted(i) && bufloaded(i)
            let j += 1
            " let bufname = fnamemodify(bufname(i), ':t')
            let bufname = bufname(i)
            let desc = printf('%s %s', i, pathshorten(bufname))
            if !empty(a:filter) && bufname !~ a:filter
                call add(post, desc)
            elseif j >= a:start_idx
                call add(buffers, desc)
            elseif a:rotate
                call add(prelude, desc)
            endif
        endif
    endfor
    " TLogVAR a:start_idx, buffers
    return buffers + prelude + post
endf


function! tinykeymap#buffers#List(start_idx) "{{{3
    return join(s:List(a:start_idx, 1, g:tinykeymap#buffers#filter), ', ')
endf

