" @Author:      Tom Link (mailto:micathom AT gmail com?subject=[vim])
" @License:     GPL (see http://www.gnu.org/licenses/gpl.txt)
" @Revision:    21


if !exists('g:tinykeymap#map#tabs#map')
    " Map leader for the "tabs" tinykeymap.
    let g:tinykeymap#map#tabs#map = "gt"   "{{{2
endif

augroup TinyKeyMapTabs
    au!
    au TabLeave * let g:mrutab = tabpagenr()
augroup END


" Based on Andy Wokulas's tabs mode for tinymode.
call tinykeymap#EnterMap('tabs', g:tinykeymap#map#tabs#map, {'name': 'tabs mode'})
call tinykeymap#Map('tabs', 'n', 'tabnew') 
call tinykeymap#Map('tabs', 't', 'norm! gt') 
call tinykeymap#Map('tabs', 'T', 'norm! gT') 
call tinykeymap#Map('tabs', "<Right>", 'norm! gt')
call tinykeymap#Map('tabs', "<Left>", 'norm! gT')
call tinykeymap#Map('tabs', "<Up>", 'exec "tabmove" (max([1, tabpagenr() - 1]) - 1)')
call tinykeymap#Map('tabs', "<Down>", 'exec "tabmove" (max([0, tabpagenr() - 1]) + 1)')
call tinykeymap#Map("tabs", "^", "tabfirst")
call tinykeymap#Map("tabs", "$", "tablast")
call tinykeymap#Map("tabs", "<Home>", "tabfirst")
call tinykeymap#Map("tabs", "<End>", "tablast")
call tinykeymap#Map("tabs", "c", "tabclose")
call tinykeymap#Map("tabs", "<Del>", "tabclose")
call tinykeymap#Map("tabs", "<BS>", "tabclose")
call tinykeymap#Map("tabs", "<c-o>", "call tinykeymap#tabs#MRU()", {'name': 'Go to most recently used tab'})

