" @Author:      Tom Link (mailto:micathom AT gmail com?subject=[vim])
" @License:     GPL (see http://www.gnu.org/licenses/gpl.txt)
" @Created:     2012-09-06.
" @Last Change: 2012-09-06.
" @Revision:    34

if !exists('g:tinykeymap#qfl#map')
    let g:tinykeymap#qfl#map = g:tinykeymap#mapleader .'q'   "{{{2
endif


if !exists('g:tinykeymap#qfl#options')
    let g:tinykeymap#qfl#options = {
                \ 'timeout': 0,
                \ 'start': 'cwindow',
                \ 'stop': 'cclose'
                \ }
endif


if !exists('g:tinykeymap#qfl#bang')
    " String to add after some qfl related commands.
    let g:tinykeymap#qfl#bang = &hidden ? '!' : ''   "{{{2
endif


call tinykeymap#EnterMap("quickfixlist", g:tinykeymap#qfl#map, g:tinykeymap#qfl#options)

call tinykeymap#Map('quickfixlist', 'c', 'cc'. g:tinykeymap#qfl#bang .' <count>')
call tinykeymap#Map('quickfixlist', 'n', '<count>cnext'. g:tinykeymap#qfl#bang)
call tinykeymap#Map('quickfixlist', 'p', '<count>cNext'. g:tinykeymap#qfl#bang)
call tinykeymap#Map('quickfixlist', 'j', '<count>cnext'. g:tinykeymap#qfl#bang)
call tinykeymap#Map('quickfixlist', 'k', '<count>cNext'. g:tinykeymap#qfl#bang)
call tinykeymap#Map('quickfixlist', 'h', '<count>cnfile'. g:tinykeymap#qfl#bang)
call tinykeymap#Map('quickfixlist', 'l', '<count>cNfile'. g:tinykeymap#qfl#bang)
call tinykeymap#Map('quickfixlist', '^', 'crewind'. g:tinykeymap#qfl#bang .' <count>')
call tinykeymap#Map('quickfixlist', '$', 'clast'. g:tinykeymap#qfl#bang .' <count>')
call tinykeymap#Map('quickfixlist', '<Down>', '<count>cnext'. g:tinykeymap#qfl#bang)
call tinykeymap#Map('quickfixlist', '<Up>', '<count>cNext'. g:tinykeymap#qfl#bang)
call tinykeymap#Map('quickfixlist', '<Right>', '<count>cnfile'. g:tinykeymap#qfl#bang)
call tinykeymap#Map('quickfixlist', '<Left>', '<count>cNfile'. g:tinykeymap#qfl#bang)
call tinykeymap#Map('quickfixlist', '<Home>', 'crewind'. g:tinykeymap#qfl#bang .' <count>')
call tinykeymap#Map('quickfixlist', '<End>', 'clast'. g:tinykeymap#qfl#bang .' <count>')
call tinykeymap#Map('quickfixlist', '<PageUp>', 'colder <count>')
call tinykeymap#Map('quickfixlist', '<PageDown>', 'cnewer <count>')
call tinykeymap#Map('quickfixlist', '<C-B>', 'colder <count>')
call tinykeymap#Map('quickfixlist', '<C-F>', 'cnewer <count>')
call tinykeymap#Map('quickfixlist', '<Space>', 'clist')
call tinykeymap#Map('quickfixlist', 'w', 'cwindow <count>')
call tinykeymap#Map('quickfixlist', 'W', 'cclose')

