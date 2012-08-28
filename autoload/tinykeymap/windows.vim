" windows.vim
" @Author:      Tom Link (mailto:micathom AT gmail com?subject=[vim])
" @License:     GPL (see http://www.gnu.org/licenses/gpl.txt)
" @Created:     2012-08-28.
" @Last Change: 2012-08-28.
" @Revision:    3

" Based on Andy Wokulas's windows mode for tinymode.
call tinykeymap#EnterMap("windows", "<C-W>", {'name': 'windows mode'})
call tinykeymap#Map('windows', '>', 'wincmd >') 
call tinykeymap#Map('windows', '<', 'wincmd <') 
call tinykeymap#Map('windows', '+', 'wincmd +') 
call tinykeymap#Map('windows', '-', 'wincmd -') 
call tinykeymap#Map('windows', 't', 'wincmd t') 
call tinykeymap#Map('windows', 'b', 'wincmd b') 
call tinykeymap#Map('windows', "\<up>", 'wincmd W', {'exit': 1, 'name': '<up>'}) 
call tinykeymap#Map('windows', "\<down>", 'wincmd w', {'exit': 1, 'name': '<down>'}) 

