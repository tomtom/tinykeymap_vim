" tinykeymap.vim
" @Author:      Tom Link (mailto:micathom AT gmail com?subject=[vim])
" @License:     GPL (see http://www.gnu.org/licenses/gpl.txt)
" @Created:     2012-08-27.
" @Last Change: 2012-08-28.
" @Revision:    175

if !exists('g:tinykeymap#timeout')
    let g:tinykeymap#timeout = 3000   "{{{2
endif


if !exists('g:tinykeymap#resolution')
    let g:tinykeymap#resolution = "200m"   "{{{2
endif


let s:tinykeymaps = {}
let s:oid = "\<esc>options"


" Load pre-defined tinykeymaps.
" [maps] is either a single name or a list of names.
"
" Run >
"     :echo globpath(&rtp, 'autoload/tinykeymap/*.vim')
" for a list of available tinykeymaps.
function! tinykeymap#Load(maps) "{{{3
    if type(a:maps) == 3
        let maps = a:maps
    else
        let maps = [a:maps]
    endif
    for map in maps
        " TLogVAR map
        for file in split(globpath(&rtp, 'autoload/tinykeymap/'. map .'.vim'), '\n')
            " TLogVAR file
            exec 'source' file
        endfor
    endfor
endf


" :display: tinykeymap#EnterMap(name, map, ?options={})
" If you press [map], the tinykeymap [name] becomes effective.
"
" Pressing <Esc> or an undefined key, causes the tinykeymap to stop. If 
" an undefined keymap is pressed right after [map], [map][key] is queued 
" for processing via |feedkeys()|.
"
" Options may contain the following keys:
"   mode ... A map mode (see |maparg()|)
"   buffer ... Make the tinykeymap buffer-local
function! tinykeymap#EnterMap(name, map, ...) "{{{3
    let options = a:0 >= 1 ? a:1 : {}
    let mode = get(options, 'mode', 'n')
    let buffer_local = get(options, 'buffer', 0) ? '<buffer>' : ''
    let cmd  = mode . "map"
    let rhs  = s:RHS(mode, ':call <SID>EnterMap('. string(a:name) .')<cr>')
    exec cmd buffer_local a:map rhs
    if empty(buffer_local)
        let dict = s:tinykeymaps
    else
        if !exists('b:tinykeymaps')
            let b:tinykeymaps = {}
        endif
        let dict = b:tinykeymaps
    endif
    let options.map = a:map
    let dict[a:name] = {s:oid : copy(options)}
endf


" :display: tinykeymap#Map(name, key, expr, ?options={})
" When the tinykeymap [name] is in effect, pressing [key] causes [expr] 
" to be |:execute|d.
"
" Options may contain the following keys:
"   exit ... If true, exit the current tinykeymap after evaluating 
"            [expr]
function! tinykeymap#Map(name, key, expr, ...) "{{{3
    let dict = s:GetDict(a:name)
    let def = {'expr': a:expr, 'options': a:0 >= 1 ? a:1 : {}}
    let dict[a:key] = def
endf


function! s:GetDict(name) "{{{3
    if exists('b:tinykeymaps') && has_key(b:tinykeymaps, a:name)
        return b:tinykeymaps[a:name]
    elseif has_key(s:tinykeymaps, a:name)
        return s:tinykeymaps[a:name]
    else
        throw "tinykeymaps: Unknown map: ". a:name
    endif
endf


function! s:RHS(mode, map) "{{{3
    if a:mode ==# 'n'
        let pre  = ''
        let post = ''
    elseif a:mode ==# 'i'
        let pre = '<c-\><c-o>'
        let post = ''
    elseif a:mode ==# 'v' || a:mode ==# 'x'
        let pre = '<c-c>'
        let post = '<C-\><C-G>'
    elseif a:mode ==# 'c'
        let pre = '<c-c>'
        let post = '<C-\><C-G>'
    elseif a:mode ==# 'o'
        let pre = '<c-c>'
        let post = '<C-\><C-G>'
    endif
    return pre . a:map . post
endf


function! s:EnterMap(name) "{{{3
    let rv = ''
    let dict = s:GetDict(a:name)
    let msg = get(dict[s:oid], 'name', a:name)
    let keys = keys(dict)
    let keys = filter(keys, 'v:val[0:0] != "\<esc>"')
    let keys = map(keys, 'get(dict[v:val].options, "name", v:val)')
    let keys = sort(keys)
    call add(keys, '<Esc>')
    let message = printf("tinykeymap: %s (keys: %s)", msg, join(keys, '/'))
    let pos = getpos('.')
    let first_run = 1
    let t = 0
    let s:count = ''
    while t < g:tinykeymap#timeout
        let key = getchar(0)
        " TLogVAR key
        if type(key) == 0 && key == 0
            echo message
            exec 'sleep' g:tinykeymap#resolution
        elseif type(key) == 0 && key == 27
            break
        else
            let status = s:ProcessKey(a:name, key)
            if status > 0
                let t = 0
                let first_run = 0
            elseif status < 0
                let char = s:KeyChar(key)
                if first_run
                    let map = dict[s:oid].map
                    let map = escape(map, '\')
                    let map = substitute(map, '<', '\\<', 'g')
                    let map = eval('"'. map .'"')
                    let fkeys = map . char
                else
                    let fkeys = char
                endif
                " TLogVAR first_run, fkeys
                call feedkeys(fkeys, 'n')
                break
            else
                break
            endif
        endif
        redraw
    endwh
    echo "tinykeymaps: Leave ". msg
    return rv
endf


function! s:ProcessKey(name, key) "{{{3
    " TLogVAR a:name, a:key
    let cont = 1
    let key = s:KeyChar(a:key)
    " TLogVAR a:key, key
    if type(a:key) == 0 && a:key > 48 && a:key < 58
        let s:count .= key
        " echom "DBG ProcessKey 1: s:count" s:count
    else
        let dict = s:GetDict(a:name)
        " TLogVAR dict
        " TLogVAR key
        if has_key(dict, key)
            let def = get(dict, key, '')
            if get(def.options, 'exit', 0)
                let cont = 0
            endif
            let expr = def.expr
            " TLogVAR def, expr
            let iterations = 1
            " echom "DBG ProcessKey 2: s:count" s:count
            if expr =~ '\V<count>'
                let expr = substitute(expr, '\V<count>', s:count, 'g')
            elseif !empty(s:count)
                let iterations = str2nr(s:count)
            endif
            if iterations == 0
                let iterations = 1
            endif
            let s:count = ''
            let expr = substitute(expr, '\V<lt>', '<', 'g')
            " TLogVAR iterations, expr
            if !empty(expr)
                for i in range(iterations)
                    exec expr
                endfor
            endif
        else
            let cont = -1
        endif
    endif
    return cont
endf


function! s:KeyChar(key) "{{{3
    if type(a:key) == 1
        return a:key
    else
        return nr2char(a:key)
    endif
endf

