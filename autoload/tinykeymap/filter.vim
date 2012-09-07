" @Author:      Tom Link (mailto:micathom AT gmail com?subject=[vim])
" @License:     GPL (see http://www.gnu.org/licenses/gpl.txt)
" @Created:     2012-09-06.
" @Last Change: 2012-09-06.
" @Revision:    112

if !exists('g:tinykeymap#filter#map')
    let g:tinykeymap#filter#map = g:tinykeymap#mapleader .'f'   "{{{2
endif


if !exists('g:tinykeymap#filter#options')
    let g:tinykeymap#filter#options = {
                \ 'message': 'printf("filter: %s", g:tinykeymap#filter#rx)',
                \ 'start': 'let g:tinykeymap#filter#rx = expand("<cword>") | let s:fdm = [&l:fdm, &l:nu, &l:cul] | setl fdm=manual | setl nu | setl cul | call tinykeymap#filter#Process()',
                \ 'stop': 'unlet! g:tinykeymap#filter#rx | exec "norm! zE" | let [&l:fdm, &l:nu, &l:cul] = s:fdm | 3match none',
                \ 'after': 'call tinykeymap#filter#Process()',
                \ 'unknown_key': 'tinykeymap#filter#UnkownKey',
                \ 'disable_count': 1,
                \ 'timeout': 0
                \ }
endif


call tinykeymap#EnterMap("filter", g:tinykeymap#filter#map, g:tinykeymap#filter#options)

call tinykeymap#Map('filter', '<Del>', 'if len(g:tinykeymap#filter#rx) > 0 | let g:tinykeymap#filter#rx = g:tinykeymap#filter#rx[1 : -1] | endif',
            \ {'desc': 'Remove first character'})
call tinykeymap#Map('filter', '<BS>', 'if len(g:tinykeymap#filter#rx) > 0 | let g:tinykeymap#filter#rx = g:tinykeymap#filter#rx[0 : -2] | endif',
            \ {'desc': 'Remove last character'})
call tinykeymap#Map('filter', '<C-BS>', 'if len(g:tinykeymap#filter#rx) > 0 | let g:tinykeymap#filter#rx = substitute(g:tinykeymap#filter#rx, ''\(^\|\s\+\)\S\+$'', "", "") | endif',
            \ {'desc': 'Remove last word'})
call tinykeymap#Map('filter', '<C-Del>', 'if len(g:tinykeymap#filter#rx) > 0 | let g:tinykeymap#filter#rx = substitute(g:tinykeymap#filter#rx, ''^\S\+\(\s\+\|$\)'', "", "") | endif',
            \ {'desc': 'Remove first word'})
call tinykeymap#Map('filter', '<Up>', 'norm! k')
call tinykeymap#Map('filter', '<Down>', 'norm! j')


function! tinykeymap#filter#Process() "{{{3
    norm! zE
    if !empty(g:tinykeymap#filter#rx)
        let pos = getpos('.')
        try
            let lend = line('$')
            let from = 0
            norm! gg0
            let to = search(g:tinykeymap#filter#rx, 'cW')
            " TLogVAR g:tinykeymap#filter#rx, from, to
            while to > 0 && from < lend
                if to > 1 && to > from + 1
                    call s:Fold(from, to - 1)
                endif
                let from = to + 1
                exec from
                let to = search(g:tinykeymap#filter#rx, 'W')
                " TLogVAR g:tinykeymap#filter#rx, from, to
            endwh
            if from > 1 && from < lend
                call s:Fold(from, lend)
            endif
        finally
            call setpos('.', pos)
        endtry
    endif
    exec printf('3match IncSearch /%s/', g:tinykeymap#filter#rx)
endf


function! s:Fold(from, to) "{{{3
    let fold = printf('%s,%sfold', a:from, a:to)
    " TLogVAR fold
    exec fold
endf


function! tinykeymap#filter#UnkownKey(chars, count) "{{{3
    let g:tinykeymap#filter#rx .= join(a:chars, '')
    return 1
endf

