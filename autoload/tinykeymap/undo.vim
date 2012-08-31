" undo.vim
" @Author:      Tom Link (mailto:micathom AT gmail com?subject=[vim])
" @Website:     <+WWW+>
" @License:     GPL (see http://www.gnu.org/licenses/gpl.txt)
" @Created:     2012-08-30.
" @Last Change: 2012-08-30.
" @Revision:    24

call tinykeymap#EnterMap("undo", g:mapleader ."u", {
            \ 'name': 'undo mode',
            \ 'message': 'printf("cur: %s, time: %s", undotree().seq_cur, strftime("%c", undotree().time_cur))'
            \ })
call tinykeymap#Map('undo', 'u', 'undo')
call tinykeymap#Map('undo', '<Left>', 'undo')
call tinykeymap#Map('undo', 'U', 'norm! U')
call tinykeymap#Map('undo', 'r', 'redo')
call tinykeymap#Map('undo', '<Right>', 'redo')
call tinykeymap#Map('undo', '<Space>', 'undolist | call tinykeymap#PressEnter()')
call tinykeymap#Map('undo', '+', 'norm! g+')
call tinykeymap#Map('undo', '<Down>', 'norm! g+')
call tinykeymap#Map('undo', '-', 'norm! g-')
call tinykeymap#Map('undo', '<Up>', 'norm! g-')
call tinykeymap#Map('undo', 'e', 'earlier <count1>')
call tinykeymap#Map('undo', 's', 'earlier <count1>s')
call tinykeymap#Map('undo', 'm', 'earlier <count1>m')
call tinykeymap#Map('undo', 'h', 'earlier <count1>h')
call tinykeymap#Map('undo', 'd', 'earlier <count1>d')
call tinykeymap#Map('undo', 'f', 'earlier <count1>f')
call tinykeymap#Map('undo', 'l', 'later <count1>')
call tinykeymap#Map('undo', 'S', 'later <count1>s')
call tinykeymap#Map('undo', 'M', 'later <count1>m')
call tinykeymap#Map('undo', 'H', 'later <count1>h')
call tinykeymap#Map('undo', 'D', 'later <count1>d')
call tinykeymap#Map('undo', 'F', 'later <count1>f')

