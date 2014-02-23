" @Author:      Tom Link (micathom AT gmail com?subject=[vim])
" @Website:     http://www.vim.org/account/profile.php?user_id=4037
" @GIT:         http://github.com/tomtom/tabs_vim
" @License:     GPL (see http://www.gnu.org/licenses/gpl.txt)
" @Revision:    8


" Contributed by Daniel Hahler
function! tinykeymap#tabs#MRU() "{{{3
    if !exists('g:mrutab')
        let g:mrutab = 1
    endif
    let tpnr = tabpagenr()
    if g:mrutab > tabpagenr('$') || g:mrutab == tpnr
        if g:mrutab > 1
            " go to the left
            let g:mrutab = tpnr - 1
        else
            echohl WarningMsg
            echom 'There is only one tab!'
            echohl NONE
            return
        endif
    endif
    exec 'tabn' g:mrutab
endf

