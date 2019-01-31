" @Author:      Tom Link (mailto:micathom AT gmail com?subject=[vim])
" @Website:     https://github.com/tomtom
" @License:     GPL (see http://www.gnu.org/licenses/gpl.txt)
" @Last Change: 2017-08-23
" @Revision:    22


if !exists('g:tinykeymap#map#folds#map')
    " Map leader for the "folds" tinykeymap.
    let g:tinykeymap#map#folds#map = g:tinykeymap#mapleader ."F"   "{{{2
endif


if !exists('g:tinykeymap#map#folds#register')
    let g:tinykeymap#map#folds#register = 'f'   "{{{2
endif


if !exists('g:tinykeymap#map#folds#options')
    let g:tinykeymap#map#folds#options = {
                \ 'message': 'printf("<%d,%d>", line("."), col("."))',
                \ 'start': 'let s:register = @'. g:tinykeymap#map#folds#register .' | let @'. g:tinykeymap#map#folds#register .' = "" | let s:folds_options = [&l:cul, &lz, &rnu] | let &l:cul = 1 | let &lz = 0 | setlocal rnu | norm! zX',
                \ 'stop': 'let @'. g:tinykeymap#map#folds#register .' = s:register | let [&l:cul, &lz, &rnu] = s:folds_options | unlet s:folds_options',
                \ }
    if exists('g:loaded_tlib')
        let g:tinykeymap#map#folds#options.after = 'call tlib#buffer#ViewLine(line("."))'
    else
        let g:tinykeymap#map#folds#options.after = 'norm! zz'
    endif
endif


call tinykeymap#EnterMap("folds", g:tinykeymap#map#folds#map, g:tinykeymap#map#folds#options)

call tinykeymap#Map('folds', '<CR>', 'norm! zv', {'exit': 1})

call tinykeymap#Map('folds', '<Home>', 'norm! gg0')
call tinykeymap#Map('folds', '<End>', 'norm! G0')

call tinykeymap#Map('folds', '<Down>', 'norm! zj')
call tinykeymap#Map('folds', '<Up>', 'norm! zk')
call tinykeymap#Map('folds', '+', 'norm! zr')
call tinykeymap#Map('folds', '-', 'norm! zm')

call tinykeymap#Map('folds', 'v', 'norm! zv[zV]z')
call tinykeymap#Map('folds', 'd', 'norm! zv[zV]z"'. g:tinykeymap#map#folds#register .'d')
call tinykeymap#Map('folds', 'y', 'norm! zv[zV]z"'. g:tinykeymap#map#folds#register .'y')
call tinykeymap#Map('folds', 'p', 'norm! "'. g:tinykeymap#map#folds#register .'p')
call tinykeymap#Map('folds', 'P', 'norm! "'. g:tinykeymap#map#folds#register .'P')

for s:ch in ['o', 'O', 'c', 'C', 'a', 'A', 'v', 'x', 'X', 'm', 'M', 'r', 'R', 'j', 'k']
    call tinykeymap#Map('folds', s:ch, 'norm! z'. s:ch)
endfor
unlet! s:ch

for s:ch in ['[', ']']
    call tinykeymap#Map('folds', s:ch, 'norm! '. s:ch .'z')
endfor
unlet! s:ch

