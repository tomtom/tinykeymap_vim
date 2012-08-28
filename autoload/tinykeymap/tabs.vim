" tabs.vim
" @Author:      Tom Link (mailto:micathom AT gmail com?subject=[vim])
" @License:     GPL (see http://www.gnu.org/licenses/gpl.txt)
" @Created:     2012-08-28.
" @Last Change: 2012-08-28.
" @Revision:    3

" Based on Andy Wokulas's tabs mode for tinymode.
call tinykeymap#EnterMap('tabs', 'gt', {'name': 'tabs mode'})
call tinykeymap#Map('tabs', 'n', 'tabnew') 
call tinykeymap#Map('tabs', 't', 'norm! gt') 
call tinykeymap#Map('tabs', 'T', 'norm! gT') 
call tinykeymap#Map("tabs", "0", "tabfirst")
call tinykeymap#Map("tabs", "$", "tablast")
call tinykeymap#Map("tabs", "c", "tabclose")

