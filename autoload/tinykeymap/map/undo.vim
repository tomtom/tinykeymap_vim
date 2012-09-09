" undo.vim
" @Author:      Tom Link (mailto:micathom AT gmail com?subject=[vim])
" @Website:     <+WWW+>
" @License:     GPL (see http://www.gnu.org/licenses/gpl.txt)
" @Created:     2012-08-30.
" @Last Change: 2012-09-09.
" @Revision:    40


if !exists('g:tinykeymap#map#undo#map')
    " Map leader for the "undo" tinykeymap.
    " If the undotree plugin is available, |:UndotreeToggle| will be 
    " called when entering the undo tinykeymap.
    let g:tinykeymap#map#undo#map = g:tinykeymap#mapleader ."u"   "{{{2
endif


if !exists('tinykeymap#map#undo#options')
    let tinykeymap#map#undo#options = {
                \ 'name': 'undo mode',
                \ 'message': 'printf("cur: %s, time: %s", undotree().seq_cur, strftime("%c", undotree().time_cur))'
                \ }
    if exists(':UndotreeToggle')
        let tinykeymap#map#undo#options.start = 'if bufwinnr("undotree_") == -1 | UndotreeToggle | endif'
        let tinykeymap#map#undo#options.stop = 'if bufwinnr("undotree_") != -1 | UndotreeToggle | endif'
        let tinykeymap#map#undo#options.after = 'doautocmd CursorMoved'
    endif
endif


call tinykeymap#EnterMap("undo", g:tinykeymap#map#undo#map, tinykeymap#map#undo#options)
call tinykeymap#Map('undo', 'u', 'undo')
call tinykeymap#Map('undo', '<Down>', 'undo')
call tinykeymap#Map('undo', 'U', 'norm! U')
call tinykeymap#Map('undo', 'r', 'redo')
call tinykeymap#Map('undo', '<Up>', 'redo')
call tinykeymap#Map('undo', '<Space>', 'undolist | call tinykeymap#PressEnter()')
call tinykeymap#Map('undo', '+', 'norm! g+')
call tinykeymap#Map('undo', '<Left>', 'norm! g+')
call tinykeymap#Map('undo', '-', 'norm! g-')
call tinykeymap#Map('undo', '<Right>', 'norm! g-')
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

