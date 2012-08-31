" tinykeymap.vim
" @Author:      Tom Link (mailto:micathom AT gmail com?subject=[vim])
" @License:     GPL (see http://www.gnu.org/licenses/gpl.txt)
" @Created:     2012-08-27.
" @Last Change: 2012-08-31.
" @Revision:    338


if !exists('g:tinykeymap#conflict')
    " Conflict resolution if a map is already defined (see 
    " |tinykeymap#EnterMap|):
    "   0 ... Don't create a lead map
    "   1 ... Don't create a lead map and display a message
    "   2 ... Create a new lead map and display a message
    "   3 ... Create a new lead map
    "   4 ... Throw an error
    let g:tinykeymap#conflict = 0   "{{{2
endif


if !exists('g:tinykeymap#timeout')
    let g:tinykeymap#timeout = 5000   "{{{2
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
"   message ... An expression that returns a message string (the string 
"       will be shortened if necessary
"   start ... An expression |:execute|d before entering the map
"   stop ... An expression |:execute|d after leaving the map
"   after ... An execute |:execute|d after processing a character
"
" CAUTION: Currently only normal mode maps (mode == "n") are supported. 
" It is possible to define other type of maps but the behaviour is 
" untested/undefined.
function! tinykeymap#EnterMap(name, map, ...) "{{{3
    let options = a:0 >= 1 ? a:1 : {}
    let mode = get(options, 'mode', 'n')
    if !empty(maparg(a:map, mode))
        let warning_msg = "tinykeymap: Map already defined: ". a:name ." ". a:map
        if g:tinykeymap#conflict == 1 || g:tinykeymap#conflict == 2
            echohl WarningMsg
            echom warningmsg
            echohl NONE
        endif
        if g:tinykeymap#conflict <= 1
            return
        elseif g:tinykeymap#conflict == 4
            throw warning_msg
        endif
    endif
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
    if !has_key(options, 'name')
        let options.name = a:name
    endif
    let dict[a:name] = {s:oid : copy(options)}
endf


" :display: tinykeymap#Map(name, key, expr, ?options={})
" When the tinykeymap [name] is in effect, pressing [key] causes [expr] 
" to be |:execute|d.
"
" [key] must not be <Esc>, <Del> or <F1>. If [key] is a numeric value, 
" such a map could cause conflicts when using a [count].
"
" The following keys are handled by tinykeymaps and can/should not be 
" used in maps since they may cause conflicts.
"
"   Numeric value ... Add to [count]
"   <Esc> ... Exit a tinykeymap
"   <Del> ... Remove the last digit from [count]
"   <F1>  ... Display some help
"
" Any occurence of "<count>" in [expr] is replaced with the current 
" [count]. Occurences of "<lt>" are replaced with "<".
" "<count1>" works similar but a value of 1 is inserted anyway.
"
" Options may contain the following keys:
"   name ... The key's name (to be displayed in the help)
"   exit ... If true, exit the current tinykeymap after evaluating 
"           [expr]
function! tinykeymap#Map(name, key, expr, ...) "{{{3
    let dict = s:GetDict(a:name)
    let def = {'expr': a:expr, 'options': a:0 >= 1 ? a:1 : {}}
    if !has_key(def.options, 'name')
        let def.options.name = a:key
    endif
    let keycode = s:Keycode(a:key)
    let dict[keycode] = def
endf


function! s:Keycode(key) "{{{3
    let keycode = escape(a:key, '\')
    let keycode = substitute(keycode, '<', '\\<', 'g')
    let keycode = eval('"'. keycode .'"')
    return keycode
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
    let maxlen = float2nr(&columns * 0.8)
    " let maxlen = float2nr((&columns * &cmdheight) * 0.8)
    " let keys = keys(dict)
    " let keys = filter(keys, 'v:val[0:0] != "\<esc>"')
    " let keys = map(keys, 'get(dict[v:val].options, "name", v:val)')
    " let keys = sort(keys)
    " call add(keys, '<Esc>')
    " call add(keys, '<F1>')
    " let message = printf("tinykeymap: %s (keys: %s)", msg, join(keys, '/'))
    " if strlen(message) > float2nr(&columns * 0.8)
    let message0 = "-- tinykeymap ". msg ." (help <F1>)%s --"
    " endif
    let messenger = get(dict[s:oid], 'message', '')
    if empty(messenger)
        let laststatus = -1
        let statusline = ""
    else
        let laststatus = &laststatus
        set laststatus=2
        let statusline = &statusline
    endif
    let pos = getpos('.')
    let first_run = 1
    let time = 0
    let s:count = ''
    let ruler = &ruler
    let showcmd = &showcmd
    echo
    let before = get(dict[s:oid], 'before', '')
    let after = get(dict[s:oid], 'after', '')
    let start = get(dict[s:oid], 'start', '')
    if !empty(start)
        exec start
    endif
    try
        while time < g:tinykeymap#timeout
            let key = getchar(0)
            " TLogVAR key
            if type(key) == 0 && key == 0
                if empty(s:count)
                    let message = printf(message0, '')
                else
                    let message = printf(message0, ' '. s:count)
                endif
                if !empty(messenger)
                    let mapmsg = eval(messenger)
                    " if !empty(mapmsg)
                    "     let message .= ' '. mapmsg
                    " endif
                    if strlen(mapmsg) >= &columns
                        let mapmsg = mapmsg[0 : &columns - 4] . '...'
                    endif
                    let &statusline = mapmsg
                endif
                if strlen(message) > maxlen
                    let message = message[0 : maxlen - 4] . '...'
                endif
                redraw
                echohl ModeMsg
                echo message
                echohl NONE
                exec 'sleep' g:tinykeymap#resolution
                let time += g:tinykeymap#resolution
            elseif type(key) == 0 && key == 27
                break
            elseif type(key) == 1 && key == "\<F1>"
                call s:Help(dict)
            elseif type(key) == 1 && key == "\<Del>"
                if !empty(s:count)
                    let s:count = s:count[0 : -2]
                endif
            else
                let status = s:ProcessKey(a:name, key, before)
                " TLogVAR status
                if status > 0
                    let time = 0
                    let first_run = 0
                    if !empty(after)
                        exec after
                    endif
                elseif status < 0
                    let char = s:KeyChar(key)
                    if first_run
                        if time > &timeoutlen
                            let fkeys = char
                            let mode = 'm'
                        else
                            let map = dict[s:oid].map
                            let keycode = s:Keycode(map)
                            let fkeys = keycode . char
                            let mode = 'n'
                        endif
                    else
                        let fkeys = char
                        let mode = 'm'
                    endif
                    " TLogVAR time, first_run, fkeys, mode
                    call feedkeys(fkeys, mode)
                    break
                else
                    break
                endif
            endif
        endwh
        " echo "tinykeymaps: Leave ". msg
        echo ""
        redraw
    finally
        let stop = get(dict[s:oid], 'stop', '')
        if !empty(stop)
            exec stop
        endif
        let &ruler = ruler
        let &showcmd = showcmd
        if laststatus >= 0
            let &laststatus = laststatus
            let &statusline = statusline
        endif
    endtry
    return rv
endf


function! s:Help(dict) "{{{3
    " TLogVAR a:dict
    echo "tinykeymap: Help for ". a:dict[s:oid].name
    for [key, def] in sort(items(a:dict))
        if key !~ "^\<Esc>"
            let key = get(def.options, 'name', key)
            let msg = get(def.options, 'desc', def.expr)
            if has_key(def.options, 'exit')
                let msg .= ' -> EXIT'
            endif
            echo printf('  %s: %s', key, msg)
        endif
    endfor
    call tinykeymap#PressEnter()
    redraw
endf


function! tinykeymap#PressEnter() "{{{3
    echohl MoreMsg
    try
        call input("--- Press ENTER to continue ---")
    finally
        echohl NONE
    endtry
endf


function! s:ProcessKey(name, key, before) "{{{3
    " TLogVAR a:name, a:key
    let cont = 1
    let key = s:KeyChar(a:key)
    " TLogVAR a:key, key
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
        elseif expr =~ '\V<count1>'
            let count1 = s:count == 0 ? 1 : s:count
            let expr = substitute(expr, '\V<count1>', count1, 'g')
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
            if !empty(a:before)
                exec a:before
            endif
            for i in range(iterations)
                exec expr
            endfor
        endif
    elseif type(a:key) == 0 && a:key >= 48 && a:key < 58
        if a:key > 48 || !empty(s:count)
            let s:count .= key
        endif
        " echom "DBG ProcessKey 1: s:count" s:count
    else
        let cont = -1
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

