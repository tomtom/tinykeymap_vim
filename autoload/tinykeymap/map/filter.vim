" @Author:      Tom Link (mailto:micathom AT gmail com?subject=[vim])
" @License:     GPL (see http://www.gnu.org/licenses/gpl.txt)
" @Created:     2012-09-06.
" @Last Change: 2014-12-10.
" @Revision:    127

if !exists('g:tinykeymap#map#filter#map')
    let g:tinykeymap#map#filter#map = g:tinykeymap#mapleader .'f'   "{{{2
endif


if !exists('g:tinykeymap#map#filter#options')
    let g:tinykeymap#map#filter#options = {
                \ 'message': 'printf("filter: %s", g:tinykeymap#map#filter#rx)',
                \ 'start': 'let w:tinykeymaps_fdm = tinykeymap#filter#Start()',
                \ 'stop': 'call tinykeymap#filter#Stop(w:tinykeymaps_fdm)',
                \ 'after': 'call tinykeymap#filter#Process()',
                \ 'unknown_key': 'tinykeymap#filter#UnknownKey',
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
call tinykeymap#Map('filter', '<C-o>',
            \ 'call inputsave() | let g:tinykeymap#map#filter#rx = input("Regexp: ", g:tinykeymap#map#filter#rx) | call inputrestore()',
            \ {'desc': 'Edit regexp'})
call tinykeymap#Map('filter', '<Up>', 'norm! k')
call tinykeymap#Map('filter', '<Down>', 'norm! j')
call tinykeymap#Map('filter', '<CR>',
            \ 'let w:tinykeymaps_exit = 1 |'.
            \ 'let w:tinykeymaps_fdm = [&l:fdm, w:tinykeymaps_fdm[1], w:tinykeymaps_fdm[2], &l:fdl, &l:fen]',
            \ {'desc': 'Apply filter', 'exit': 1})

