" @Author:      Tom Link (mailto:micathom AT gmail com?subject=[vim])
" @License:     GPL (see http://www.gnu.org/licenses/gpl.txt)
" @Created:     2012-09-06.
" @Last Change: 2012-09-09.
" @Revision:    114

if !exists('g:tinykeymap#map#filter#map')
    let g:tinykeymap#map#filter#map = g:tinykeymap#mapleader .'f'   "{{{2
endif


if !exists('g:tinykeymap#map#filter#options')
    let g:tinykeymap#map#filter#options = {
                \ 'message': 'printf("filter: %s", g:tinykeymap#map#filter#rx)',
                \ 'start': 'let g:tinykeymap#map#filter#rx = expand("<cword>") | let s:fdm = [&l:fdm, &l:nu, &l:cul] | setl fdm=manual | setl nu | setl cul | call tinykeymap#filter#Process()',
                \ 'stop': 'unlet! g:tinykeymap#map#filter#rx | exec "norm! zE" | let [&l:fdm, &l:nu, &l:cul] = s:fdm | 3match none',
                \ 'after': 'call tinykeymap#filter#Process()',
                \ 'unknown_key': 'tinykeymap#filter#UnkownKey',
                \ 'disable_count': 1,
                \ 'timeout': 0
                \ }
endif


call tinykeymap#EnterMap("filter", g:tinykeymap#map#filter#map, g:tinykeymap#map#filter#options)

call tinykeymap#Map('filter', '<Del>',
            \ 'if len(g:tinykeymap#map#filter#rx) > 0 | let g:tinykeymap#map#filter#rx = g:tinykeymap#map#filter#rx[1 : -1] | endif',
            \ {'desc': 'Remove first character'})
call tinykeymap#Map('filter', '<BS>',
            \ 'if len(g:tinykeymap#map#filter#rx) > 0 | let g:tinykeymap#map#filter#rx = g:tinykeymap#map#filter#rx[0 : -2] | endif',
            \ {'desc': 'Remove last character'})
call tinykeymap#Map('filter', '<C-BS>',
            \ 'if len(g:tinykeymap#map#filter#rx) > 0 | let g:tinykeymap#map#filter#rx = substitute(g:tinykeymap#map#filter#rx, ''\(^\|\s\+\)\S\+$'', "", "") | endif',
            \ {'desc': 'Remove last word'})
call tinykeymap#Map('filter', '<C-Del>',
            \ 'if len(g:tinykeymap#map#filter#rx) > 0 | let g:tinykeymap#map#filter#rx = substitute(g:tinykeymap#map#filter#rx, ''^\S\+\(\s\+\|$\)'', "", "") | endif',
            \ {'desc': 'Remove first word'})
call tinykeymap#Map('filter', '<Up>', 'norm! k')
call tinykeymap#Map('filter', '<Down>', 'norm! j')

