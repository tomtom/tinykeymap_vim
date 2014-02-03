" @Author:      Tom Link (mailto:micathom AT gmail com?subject=[vim])
" @License:     GPL (see http://www.gnu.org/licenses/gpl.txt)
" @Created:     2012-09-06.
" @Last Change: 2014-02-03.
" @Revision:    56

if !exists('g:tinykeymap#map#loc#map')
    let g:tinykeymap#map#loc#map = g:tinykeymap#mapleader .'o'   "{{{2
endif


if !exists('g:tinykeymap#map#loc#bang')
    " String to add after some loc related commands.
    let g:tinykeymap#map#loc#bang = &hidden ? '!' : ''   "{{{2
endif


if !exists('g:tinykeymap#map#loc#options')
    let g:tinykeymap#map#loc#options = {
                \ 'timeout': 0,
                \ 'start': 'lwindow | setl nu',
                \ 'stop': 'lclose | setl nonu'
                \ }
                " \ 'start': 'lwindow | setl nu| ll'. g:tinykeymap#map#loc#bang .' 1',
    if exists('g:loaded_tlib')
        let g:tinykeymap#map#loc#options.after = 'call tlib#buffer#ViewLine(line("."))'
        let g:tinykeymap#map#loc#options.start .= ' | call tlib#buffer#ViewLine(line("."))'
    else
        let g:tinykeymap#map#loc#options.after = 'norm! zz'
    endif
endif


call tinykeymap#EnterMap("location-list", g:tinykeymap#map#loc#map, g:tinykeymap#map#loc#options)

call tinykeymap#Map('location-list', '<CR>', 'll'. g:tinykeymap#map#loc#bang .' <count>', {'exit': 1})
call tinykeymap#Map('location-list', 'n', '<count>lnext'. g:tinykeymap#map#loc#bang)
call tinykeymap#Map('location-list', 'p', '<count>lNext'. g:tinykeymap#map#loc#bang)
call tinykeymap#Map('location-list', 'j', '<count>lnext'. g:tinykeymap#map#loc#bang)
call tinykeymap#Map('location-list', 'k', '<count>lNext'. g:tinykeymap#map#loc#bang)
call tinykeymap#Map('location-list', 'h', '<count>lnfile'. g:tinykeymap#map#loc#bang)
call tinykeymap#Map('location-list', 'l', '<count>lNfile'. g:tinykeymap#map#loc#bang)
call tinykeymap#Map('location-list', '^', 'lrewind'. g:tinykeymap#map#loc#bang .' <count>')
call tinykeymap#Map('location-list', '$', 'llast'. g:tinykeymap#map#loc#bang .' <count>')
call tinykeymap#Map('location-list', '<Down>', '<count>lnext'. g:tinykeymap#map#loc#bang)
call tinykeymap#Map('location-list', '<Up>', '<count>lNext'. g:tinykeymap#map#loc#bang)
call tinykeymap#Map('location-list', '<Right>', '<count>lnfile'. g:tinykeymap#map#loc#bang)
call tinykeymap#Map('location-list', '<Left>', '<count>lNfile'. g:tinykeymap#map#loc#bang)
call tinykeymap#Map('location-list', '<Home>', 'lrewind'. g:tinykeymap#map#loc#bang .' <count>')
call tinykeymap#Map('location-list', '<End>', 'llast'. g:tinykeymap#map#loc#bang .' <count>')
call tinykeymap#Map('location-list', '<PageUp>', 'lolder <count>')
call tinykeymap#Map('location-list', '<PageDown>', 'lnewer <count>')
call tinykeymap#Map('location-list', '<C-B>', 'lolder <count>')
call tinykeymap#Map('location-list', '<C-F>', 'lnewer <count>')
call tinykeymap#Map('location-list', '<Space>', 'llist')
call tinykeymap#Map('location-list', 'w', 'lwindow <count>')
call tinykeymap#Map('location-list', 'W', 'lclose')

