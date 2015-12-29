" @Author:      Tom Link (mailto:micathom AT gmail com?subject=[vim])
" @License:     GPL (see http://www.gnu.org/licenses/gpl.txt)
" @Revision:    38


if !exists('g:tinykeymap#map#tabs#map')
    " Map leader for the "tabs" tinykeymap.
    let g:tinykeymap#map#tabs#map = "gt"   "{{{2
endif

augroup TinyKeyMapTabs
    au!
    au TabLeave * let g:tkm_previous_tab = tabpagenr()
augroup END


" Based on Andy Wokulas's tabs mode for tinymode.
call tinykeymap#EnterMap('tabs', g:tinykeymap#map#tabs#map, {'name': 'tabs mode'})
call tinykeymap#Map('tabs', 'n', 'tabnew') 
call tinykeymap#Map('tabs', 'g', 'norm! <count1>gt') 
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
call tinykeymap#Map("tabs", "o", "tabonly!", {'exit': 1})
call tinykeymap#Map("tabs", "<Del>", "tabclose")
call tinykeymap#Map("tabs", "<BS>", "tabclose")
call tinykeymap#Map("tabs", "x", "tabclose")
call tinykeymap#Map("tabs", "p", "call tinykeymap#tabs#Previous()", {'desc': 'Previous tab'})

if exists('g:loaded_tlib') && g:loaded_tlib > 0
    call tinykeymap#Map("tabs", "s", "tabnew +TScratch!", {'desc': 'Scratch tab', 'exit': 1})
endif

