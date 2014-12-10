" filter.vim
" @Author:      Tom Link (mailto:micathom AT gmail com?subject=[vim])
" @License:     GPL (see http://www.gnu.org/licenses/gpl.txt)
" @Created:     2012-09-09.
" @Last Change: 2014-12-10.
" @Revision:    26

function! tinykeymap#filter#Process() "{{{3
    if !exists("w:tinykeymaps_exit") || !w:tinykeymaps_exit
        norm! zE
    endif
    if !empty(g:tinykeymap#map#filter#rx)
        let pos = getpos('.')
        try
            let lend = line('$')
            let from = 0
            norm! gg0
            let to = search(g:tinykeymap#map#filter#rx, 'cW')
            " TLogVAR g:tinykeymap#map#filter#rx, from, to
            while to > 0 && from < lend
                if to > 1 && to > from + 1
                    call s:Fold(from, to - 1)
                endif
                let from = to + 1
                exec from
                let to = search(g:tinykeymap#map#filter#rx, 'W')
                " TLogVAR g:tinykeymap#map#filter#rx, from, to
            endwh
            if from > 1 && from < lend
                call s:Fold(from, lend)
            endif
        finally
            call setpos('.', pos)
        endtry
    endif
    exec printf('3match IncSearch /%s/', g:tinykeymap#map#filter#rx)
    if exists('g:loaded_tlib')
        call tlib#buffer#ViewLine(line("."))
    else
        norm! zz
    endif
endf


function! tinykeymap#filter#Start(...) "{{{3
    let g:tinykeymap#map#filter#rx = a:0 >= 1 ? a:1 : expand("<cword>")
    unlet! w:tinykeymaps_exit
    let fdm = [&l:fdm, &l:nu, &l:cul, &l:fdl, &l:fen]
    if exists('w:tinykeymaps_fdm')
        for i in [0, 3, 4]
            let fdm[i] = w:tinykeymaps_fdm[i]
        endfor
    endif
    setl fdm=manual nu cul fen
    call tinykeymap#filter#Process()
    return fdm
endf


function! tinykeymap#filter#Stop(list) "{{{3
    " TLogVAR a:list
    let g:tinykeymap#map#filter#rx = ''
    " TLogVAR exists("w:tinykeymaps_exit")
    if !exists("w:tinykeymaps_exit") || !w:tinykeymaps_exit
        norm! zE
        let [&l:fdm, &l:nu, &l:cul, &l:fdl, &l:fen] = a:list
    else
        let [fdm, &l:nu, &l:cul, fdl, fen] = a:list
    endif
    " TLogVAR &l:fdm, &l:nu, &l:cul, &l:fdl, &l:fen
    3match none
    unlet! w:tinykeymaps_exit
endf


function! s:Fold(from, to) "{{{3
    let fold = printf('%s,%sfold', a:from, a:to)
    " TLogVAR fold
    exec fold
endf


function! tinykeymap#filter#UnknownKey(chars, count) "{{{3
    let g:tinykeymap#map#filter#rx .= join(a:chars, '')
    return 1
endf

