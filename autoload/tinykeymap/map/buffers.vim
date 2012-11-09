" @Author:      Tom Link (mailto:micathom AT gmail com?subject=[vim])
" @License:     GPL (see http://www.gnu.org/licenses/gpl.txt)
" @Created:     2012-08-28.
" @Last Change: 2012-09-10.
" @Revision:    112

if !exists('g:tinykeymap#map#buffers#map')
    " Map leader for the "buffers" tinykeymap.
    let g:tinykeymap#map#buffers#map = g:tinykeymap#mapleader ."b"   "{{{2
endif


call tinykeymap#EnterMap("buffers", g:tinykeymap#map#buffers#map, {
            \ 'message': 'tinykeymap#buffers#List(g:tinykeymap#buffers#idx)',
            \ 'start': 'let g:tinykeymap#buffers#idx = 1 | let g:tinykeymap#buffers#filter = ""',
            \ })
call tinykeymap#Map('buffers', '<CR>', 'call tinykeymap#buffers#Buffer(<count>)', {'exit': 1})
call tinykeymap#Map('buffers', 'd', 'drop <count>', {'exit': 1})
call tinykeymap#Map('buffers', 'b', 'buffer <count>')
call tinykeymap#Map('buffers', 's', 'sbuffer <count>')
call tinykeymap#Map('buffers', 'v', 'vert sbuffer <count>')
call tinykeymap#Map('buffers', 'n', 'bnext <count>')
call tinykeymap#Map('buffers', 'p', 'bprevious <count>')
call tinykeymap#Map('buffers', '<Down>', 'bnext <count>')
call tinykeymap#Map('buffers', '<Up>', 'bprevious <count>')
call tinykeymap#Map('buffers', '<Home>', 'bfirst')
call tinykeymap#Map('buffers', '<End>', 'blast')
call tinykeymap#Map('buffers', '<Space>', 'ls! | call tinykeymap#PressEnter()')
call tinykeymap#Map('buffers', 'D', 'bdelete <count>')
call tinykeymap#Map('buffers', '<Left>', 'call tinykeymap#buffers#Shift(-<count1>)',
            \ {'desc': 'Rotate list to the right'})
call tinykeymap#Map('buffers', '<Right>', 'call tinykeymap#buffers#Shift(<count1>)',
            \ {'desc': 'Rotate list to the left'})
call tinykeymap#Map('buffers', '/', 'let g:tinykeymap#buffers#filter = input("Filter regexp: ")',
            \ {'desc': 'Prioritize buffers matching a regexp'})


