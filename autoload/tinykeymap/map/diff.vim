" @Author:      Tom Link (mailto:micathom AT gmail com?subject=[vim])
" @License:     GPL (see http://www.gnu.org/licenses/gpl.txt)
" @Created:     2012-09-06.
" @Last Change: 2012-09-14.
" @Revision:    65

if !exists('g:tinykeymap#map#diff#map')
    let g:tinykeymap#map#diff#map = g:tinykeymap#mapleader .'d'   "{{{2
endif


if !exists('g:tinykeymap#map#diff#options')
    let g:tinykeymap#map#diff#options = {
                \ 'message': 'printf("[%s:%s lnum:%d] %s", winnr(), bufnr("%"), line("."), bufname("%"))',
                \ 'start': 'let s:diff_options = [&l:cul, &l:nu, &lz] | setl cul nu nolz',
                \ 'stop': 'let [&l:cul, &l:nu, &lz] = s:diff_options | unlet s:diff_options',
                \ 'timeout': 0
                \ }
    if exists('g:loaded_tlib')
        let g:tinykeymap#map#diff#options.after = 'call tlib#buffer#ViewLine(line("."))'
    else
        let g:tinykeymap#map#diff#options.after = 'norm! zz'
    endif
endif


call tinykeymap#EnterMap("diff", g:tinykeymap#map#diff#map, g:tinykeymap#map#diff#options)

call tinykeymap#Map('diff', '<Down>', 'norm! j')
call tinykeymap#Map('diff', '<Up>', 'norm! k')
call tinykeymap#Map('diff', '<PageDown>', 'norm! ')
call tinykeymap#Map('diff', '<PageUp>', 'norm! ')

call tinykeymap#Map('diff', '<Left>', 'norm! [c')
call tinykeymap#Map('diff', '<Right>', 'norm! ]c')

call tinykeymap#Map('diff', 'g', 'diffget')
call tinykeymap#Map('diff', 'p', 'diffput')
call tinykeymap#Map('diff', 'G', '.,+<count0>diffget')
call tinykeymap#Map('diff', 'P', '.,+<count0>diffput')

call tinykeymap#Map('diff', 'u', 'exec "buffer" expand("#") | earlier <count> | exec "buffer" expand("#")')

