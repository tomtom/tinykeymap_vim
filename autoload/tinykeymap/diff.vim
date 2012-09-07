" @Author:      Tom Link (mailto:micathom AT gmail com?subject=[vim])
" @License:     GPL (see http://www.gnu.org/licenses/gpl.txt)
" @Created:     2012-09-06.
" @Last Change: 2012-09-07.
" @Revision:    57

if !exists('g:tinykeymap#diff#map')
    let g:tinykeymap#diff#map = g:tinykeymap#mapleader .'d'   "{{{2
endif


if !exists('g:tinykeymap#diff#options')
    let g:tinykeymap#diff#options = {
                \ 'message': 'printf("[%s:%s lnum:%d] %s", winnr(), bufnr("%"), line("."), bufname("%"))',
                \ 'start': 'let s:diff_options = [&l:cul, &l:nu, &lz] | setl cul nu nolz',
                \ 'stop': 'let [&l:cul, &l:nu, &lz] = s:diff_options | unlet s:diff_options',
                \ 'after': 'redraw!',
                \ 'timeout': 0
                \ }
endif


call tinykeymap#EnterMap("diff", g:tinykeymap#diff#map, g:tinykeymap#diff#options)

call tinykeymap#Map('diff', '<Down>', 'norm! j')
call tinykeymap#Map('diff', '<Up>', 'norm! k')
call tinykeymap#Map('diff', '<PageDown>', 'norm! ')
call tinykeymap#Map('diff', '<PageUp>', 'norm! ')

call tinykeymap#Map('diff', '<Left>', 'norm! [c')
call tinykeymap#Map('diff', '<Right>', 'norm! ]c')

call tinykeymap#Map('diff', 'g', 'diffget')
call tinykeymap#Map('diff', 'p', 'diffput')

