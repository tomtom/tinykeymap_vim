" @Author:      Tom Link (micathom AT gmail com?subject=[vim])
" @Website:     http://www.vim.org/account/profile.php?user_id=4037
" @GIT:         http://github.com/tomtom/tabs_vim
" @License:     GPL (see http://www.gnu.org/licenses/gpl.txt)
" @Revision:    10


" Contributed by Daniel Hahler
function! tinykeymap#tabs#Previous() "{{{3
    if !exists('g:tkm_previous_tab')
        let g:tkm_previous_tab = 1
    endif
    let tpnr = tabpagenr()
    if g:tkm_previous_tab > tabpagenr('$') || g:tkm_previous_tab == tpnr
        if g:tkm_previous_tab > 1
            " go to the left
            let g:tkm_previous_tab = tpnr - 1
        else
            echohl WarningMsg
            echom 'There is only one tab!'
            echohl NONE
            return
        endif
    endif
    exec 'tabn' g:tkm_previous_tab
endf

