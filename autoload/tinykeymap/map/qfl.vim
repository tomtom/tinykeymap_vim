" @Author:      Tom Link (mailto:micathom AT gmail com?subject=[vim])
" @License:     GPL (see http://www.gnu.org/licenses/gpl.txt)
" @Created:     2012-09-06.
" @Last Change: 2012-09-14.
" @Revision:    45

if !exists('g:tinykeymap#map#qfl#map')
    let g:tinykeymap#map#qfl#map = g:tinykeymap#mapleader .'q'   "{{{2
endif


if !exists('g:tinykeymap#map#qfl#bang')
    " String to add after some qfl related commands.
    let g:tinykeymap#map#qfl#bang = &hidden ? '!' : ''   "{{{2
endif


if !exists('g:tinykeymap#map#qfl#options')
    let g:tinykeymap#map#qfl#options = {
                \ 'timeout': 0,
                \ 'start': 'cwindow | setl nu',
                \ 'stop': 'cclose | setl nonu'
                \ }
    if exists('g:loaded_tlib')
        let g:tinykeymap#map#qfl#options.after = 'call tlib#buffer#ViewLine(line("."))'
        let g:tinykeymap#map#qfl#options.start .= ' | call tlib#buffer#ViewLine(line("."))'
    else
        let g:tinykeymap#map#qfl#options.after = 'norm! zz'
    endif
endif


call tinykeymap#EnterMap("quickfixlist", g:tinykeymap#map#qfl#map, g:tinykeymap#map#qfl#options)

call tinykeymap#Map('quickfixlist', '<CR>', 'cc'. g:tinykeymap#map#qfl#bang .' <count>', {'exit': 1})
call tinykeymap#Map('quickfixlist', 'n', '<count>cnext'. g:tinykeymap#map#qfl#bang)
call tinykeymap#Map('quickfixlist', 'p', '<count>cNext'. g:tinykeymap#map#qfl#bang)
call tinykeymap#Map('quickfixlist', 'j', '<count>cnext'. g:tinykeymap#map#qfl#bang)
call tinykeymap#Map('quickfixlist', 'k', '<count>cNext'. g:tinykeymap#map#qfl#bang)
call tinykeymap#Map('quickfixlist', 'h', '<count>cnfile'. g:tinykeymap#map#qfl#bang)
call tinykeymap#Map('quickfixlist', 'l', '<count>cNfile'. g:tinykeymap#map#qfl#bang)
call tinykeymap#Map('quickfixlist', '^', 'crewind'. g:tinykeymap#map#qfl#bang .' <count>')
call tinykeymap#Map('quickfixlist', '$', 'clast'. g:tinykeymap#map#qfl#bang .' <count>')
call tinykeymap#Map('quickfixlist', '<Down>', '<count>cnext'. g:tinykeymap#map#qfl#bang)
call tinykeymap#Map('quickfixlist', '<Up>', '<count>cNext'. g:tinykeymap#map#qfl#bang)
call tinykeymap#Map('quickfixlist', '<Right>', '<count>cnfile'. g:tinykeymap#map#qfl#bang)
call tinykeymap#Map('quickfixlist', '<Left>', '<count>cNfile'. g:tinykeymap#map#qfl#bang)
call tinykeymap#Map('quickfixlist', '<Home>', 'crewind'. g:tinykeymap#map#qfl#bang .' <count>')
call tinykeymap#Map('quickfixlist', '<End>', 'clast'. g:tinykeymap#map#qfl#bang .' <count>')
call tinykeymap#Map('quickfixlist', '<PageUp>', 'colder <count>')
call tinykeymap#Map('quickfixlist', '<PageDown>', 'cnewer <count>')
call tinykeymap#Map('quickfixlist', '<C-B>', 'colder <count>')
call tinykeymap#Map('quickfixlist', '<C-F>', 'cnewer <count>')
call tinykeymap#Map('quickfixlist', '<Space>', 'clist')
call tinykeymap#Map('quickfixlist', 'w', 'cwindow <count>')
call tinykeymap#Map('quickfixlist', 'W', 'cclose')

