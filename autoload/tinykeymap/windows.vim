" windows.vim
" @Author:      Tom Link (mailto:micathom AT gmail com?subject=[vim])
" @License:     GPL (see http://www.gnu.org/licenses/gpl.txt)
" @Created:     2012-08-28.
" @Last Change: 2012-08-31.
" @Revision:    7

if !exists('g:tinykeymap#windows#map')
    " Map leader for the "windows" tinykeymap.
    let g:tinykeymap#windows#map = "<C-W>"   "{{{2
endif


" Based on Andy Wokulas's windows mode for tinymode.
call tinykeymap#EnterMap("windows", g:tinykeymap#windows#map, {'name': 'windows mode'})
call tinykeymap#Map('windows', '>', 'wincmd >')
call tinykeymap#Map('windows', '<', 'wincmd <')
call tinykeymap#Map('windows', '+', 'wincmd +')
call tinykeymap#Map('windows', '-', 'wincmd -')
call tinykeymap#Map('windows', 't', 'wincmd t')
call tinykeymap#Map('windows', 'b', 'wincmd b')
call tinykeymap#Map('windows', "<Up>", 'wincmd W', {'exit': 1})
call tinykeymap#Map('windows', "<Down>", 'wincmd w', {'exit': 1})

