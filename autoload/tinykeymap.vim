" tinykeymap.vim
" @Author:      Tom Link (mailto:micathom AT gmail com?subject=[vim])
" @License:     GPL (see http://www.gnu.org/licenses/gpl.txt)
" @Created:     2012-08-27.
" @Last Change: 2012-09-10.
" @Revision:    510


if !exists('g:tinykeymap#mapleader')
    " The mapleader for some tinykeymaps.
    let g:tinykeymap#mapleader = mapleader .'m'   "{{{2
endif


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
    " Stop a tinykeymap after X milliseconds.
    " If 0, the tinykeymap never stops due to a timeout.
    let g:tinykeymap#timeout = 5000   "{{{2
endif


if !exists('g:tinykeymap#resolution')
    " Number of milliseconds to sleep when polling for characters.
    let g:tinykeymap#resolution = "200m"   "{{{2
endif


if !exists('g:tinykeymap#message_fmt')
    " The format string (see |printf()|) for the tinykeymap message. This 
    " format string must contain 2 %s: The first one is for the map's 
    " name, the second one for the counter.
    let g:tinykeymap#message_fmt = "-- %s (help <F1>)%s --"   "{{{2
endif


if !exists('g:tinykeymap#show_message')
    " Where to show a tinykeymap's message. Possible values:
    "     cmdline (default value)
    "     statusline
    let g:tinykeymap#show_message = 'cmdline'   "{{{2
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
    let rv = 0
    for map in maps
        " TLogVAR map
        if empty(s:GetDict(map, {}))
            for file in split(globpath(&rtp, 'autoload/tinykeymap/map/'. map .'.vim'), '\n')
                " TLogVAR file
                exec 'source' file
                let rv = 1
            endfor
        else
            let rv = 1
        endif
    endfor
    return rv
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
"   timeout ... Map-specific value for |g:tinykeymap#timeout|
"   resolution ... Map-specific value for |g:tinykeymap#resolution|
"   unknown_key ... Function to handle unknown keys
"   disable_count ... If true, numeric values are handled as characters
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
            echom warning_msg
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
    let rhs  = s:RHS(mode, ':call tinykeymap#Call('. string(a:name) .')<cr>')
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


" :display: tinykeymap#Map(name, map, expr, ?options={})
" When the tinykeymap [name] is in effect, pressing [map] causes [expr] 
" to be |:execute|d.
"
" [map] can be a string or a list of characters. It [map] is a string, 
" tinykeymap tries to figure out which keys you meant. If it goes wrong, 
" use a list as the value of [map]. [map] must not be <Esc>, <Del> or 
" <F1>. If [map] is a numeric value, such a map could cause conflicts 
" when using a [count].
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
" "<count0>" works similar but a value of 0 is by default.
" "<count1>" works similar but a value of 1 is by default.
"
" Options may contain the following keys:
"   name ... The key's name (to be displayed in the help)
"   exit ... If true, exit the current tinykeymap after evaluating 
"   [expr]
function! tinykeymap#Map(name, map, expr, ...) "{{{3
    let dict = s:GetDict(a:name)
    if type(a:map) == 1
        let map = split(a:map, '^\(<[[:alpha:]-]\+>\)\zs\|\zs')
    elseif type(a:map) == 3
        let map = a:map
    else
        throw "tinykeymap: map must be string or a list"
    endif
    let chars = s:Map2Chars(map)
    let def = {
                \ 'chars': chars,
                \ 'expr': a:expr,
                \ 'options': a:0 >= 1 ? a:1 : {}
                \ }
    if !has_key(def.options, 'name')
        let def.options.name = join(map, '')
    endif
    call s:SetMapDef(dict, chars, def)
endf


function! s:SetMapDef(dict, chars, value) "{{{3
    let a:dict[string(a:chars)] = a:value
endf


function! s:GetMapDef(dict, chars) "{{{3
    return get(a:dict, string(a:chars), {})
endf


" Convert a map (e.g. "<space>") to keycodes.
function! s:Map2Chars(map) "{{{3
    let chars = map(copy(a:map), 's:Map2Char(v:val)')
    return chars
endf


function! s:Map2Char(key) "{{{3
    let keycode = escape(a:key, '\')
    let keycode = substitute(keycode, '<', '\\<', 'g')
    let keycode = eval('"'. keycode .'"')
    return keycode
endf


function! s:Keys2Chars(keys) "{{{3
    let chars = map(copy(a:keys), 's:Key2Char(v:val)')
    return chars
endf


function! s:Key2Char(key) "{{{3
    if type(a:key) == 1
        return a:key
    else
        return nr2char(a:key)
    endif
endf


function! s:GetDict(name, ...) "{{{3
    if exists('b:tinykeymaps') && has_key(b:tinykeymaps, a:name)
        return b:tinykeymaps[a:name]
    elseif has_key(s:tinykeymaps, a:name)
        return s:tinykeymaps[a:name]
    elseif a:0 >= 1
        return a:1
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


function! tinykeymap#Complete(ArgLead, CmdLine, CursorPos) "{{{3
    let files = split(globpath(&rtp, 'autoload/tinykeymap/map/*.vim'), '\n')
    let files = map(files, 'fnamemodify(v:val, ":t:r")')
    if !empty(a:ArgLead)
        let files = filter(files, 'strpart(v:val, 0, len(a:ArgLead)) == a:ArgLead')
    endif
    return files
endf


" :nodoc:
function! tinykeymap#Call(name) "{{{3
    if !tinykeymap#Load(a:name)
        throw "tinykeymaps: Unknown map: ". a:name
    endif
    let dict = s:GetDict(a:name)
    let options = dict[s:oid]
    let msg = get(options, 'name', a:name)
    let maxlen = float2nr(&columns * 0.8)
    " let maxlen = float2nr((&columns * &cmdheight) * 0.8)
    let messenger = get(options, 'message', '')
    if g:tinykeymap#show_message == 'statusline'
        if empty(messenger)
            let laststatus = -1
            let statusline = ""
        else
            let laststatus = &laststatus
            set laststatus=2
            let statusline = &statusline
        endif
    endif
    let pos = getpos('.')
    let first_run = 1
    let time = 0
    let s:count = ''
    let ruler = &ruler
    let showcmd = &showcmd
    echo
    let after = get(options, 'after', '')
    let start = get(options, 'start', '')
    if !empty(start)
        exec start
    endif
    try
        let keys = []
        let timeout = get(options, 'timeout', g:tinykeymap#timeout)
        let resolution = get(options, 'resolution', g:tinykeymap#resolution)
        while timeout == 0 || time < timeout
            let key = getchar(0)
            " TLogVAR key
            if type(key) == 0 && key == 0
                " TLogVAR "No key pressed"
                if empty(s:count)
                    let message = printf(g:tinykeymap#message_fmt, msg, '')
                else
                    let message = printf(g:tinykeymap#message_fmt, msg, ' '. s:count)
                endif
                if !empty(messenger)
                    let mapmsg = eval(messenger)
                    if g:tinykeymap#show_message == 'statusline'
                        let mapmsg = s:ShortMessage(mapmsg, &columns)
                        let &statusline = mapmsg
                    elseif !empty(mapmsg)
                        let message .= ' '. mapmsg
                    endif
                endif
                let message = s:ShortMessage(message, maxlen)
                redraw
                echohl ModeMsg
                echo message
                echohl NONE
                exec 'sleep' resolution
                let time += resolution
            elseif type(key) == 0 && key == 27
                " TLogVAR "<esc>"
                break
            elseif type(key) == 1 && key ==# "\<F1>"
                " TLogVAR "<f1>"
                call s:Help(dict)
            elseif type(key) == 1 && key ==# "\<Del>"
                " TLogVAR "<del>"
                if !empty(s:count)
                    let s:count = s:count[0 : -2]
                endif
            else
                " TLogVAR "other key"
                call add(keys, key)
                let status = s:ProcessKey(a:name, keys, options)
                " TLogVAR status
                if status == 0
                    let chars = s:Keys2Chars(keys)
                    if first_run
                        if time > &timeoutlen
                            let mode = 'm'
                        else
                            let map = options.map
                            let char = s:Map2Char(map)
                            call insert(chars, char)
                            let mode = 'n'
                        endif
                    else
                        let mode = 'm'
                    endif
                    let fkeys = join(chars, '')
                    " TLogVAR time, first_run, fkeys, chars, mode
                    call feedkeys(fkeys, mode)
                    break
                elseif status == 1 || status == 2
                    if !empty(after)
                        exec after
                    endif
                    if status == 2
                        " handled key + exit
                        break
                    else
                        " handled key
                        let keys = []
                        let time = 0
                        let first_run = 0
                    endif
                elseif status == 3 || status == 4
                    let time = 0
                    " count
                    if status == 4
                        let keys = []
                    endif
                else
                    throw "tinykeymap: Internal error: Unhandled status: ". status
                endif
            endif
        endwh
        " echo "tinykeymaps: Leave ". msg
        echo ""
        redraw
    finally
        let stop = get(options, 'stop', '')
        " TLogVAR stop
        if !empty(stop)
            exec stop
        endif
        let &ruler = ruler
        let &showcmd = showcmd
        if g:tinykeymap#show_message == 'statusline'
            if laststatus >= 0
                let &laststatus = laststatus
                let &statusline = statusline
            endif
        endif
    endtry
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


" Return values:
" 0 ... Unhandled key
" 1 ... Handled key + continue loop
" 2 ... Handled key + exit
" 3 ... It could be a handled key + continue loop
" 4 ... A count was entered + continue loop
function! s:ProcessKey(name, keys, options) "{{{3
    " TLogVAR a:name, a:keys, a:options
    let key = a:keys[-1]
    let chars = s:Keys2Chars(a:keys)
    " TLogVAR a:keys, chars
    let dict = s:GetDict(a:name)
    " TLogVAR dict
    " TLogVAR chars
    let handle_key = s:CheckChars(dict, chars)
    " TLogVAR handle_key
    if handle_key > 0
        let def = s:GetMapDef(dict, chars)
        let expr = def.expr
        " TLogVAR def, expr
        let iterations = 1
        " echom "DBG ProcessKey 2: s:count" s:count
        if expr =~ '\V<count>'
            let expr = substitute(expr, '\V<count>', s:count, 'g')
        elseif expr =~ '\V<count0>'
            let count0 = s:count == 0 ? 0 : s:count
            let expr = substitute(expr, '\V<count0>', count0, 'g')
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
            if has_key(a:options, 'before')
                exec a:options.before
            endif
            for i in range(iterations)
                exec expr
            endfor
        endif
        let status = get(def.options, 'exit', 0) ? 2 : 1
    elseif handle_key == 0
        let status = 3
    elseif !get(a:options, 'disable_count', 0) && type(key) == 0 && key >= 48 && key < 58
        if key > 48 || !empty(s:count)
            let s:count .= nr2char(key)
        endif
        " echom "DBG ProcessKey 1: s:count" s:count
        let status = 4
    elseif has_key(a:options, 'unknown_key')
        if has_key(a:options, 'before')
            exec a:options.before
        endif
        if call(a:options.unknown_key, [chars, str2nr(s:count)])
            let status = 1
        else
            let status = 0
        endif
    else
        let status = 0
    endif
    " TLogVAR status
    return status
endf


function! s:ShortMessage(string, len) "{{{3
    if strlen(a:string) > a:len
        return a:string[0 : a:len - 4] . '...'
    else
        return a:string
    endif
endf


" Return values:
" 1  ... full match
" 0  ... partial match
" -1 ... no match
function! s:CheckChars(dict, chars) "{{{3
    " TLogVAR a:dict
    " TLogVAR a:chars
    let rv = -1
    let alen = len(a:chars)
    let sakeys = string(a:chars)
    " TLogVAR sakeys, alen
    for [sokeys, def] in items(a:dict)
        if sokeys != s:oid
            " TLogVAR sokeys, def
            let ochars = def.chars
            let llen = len(ochars)
            " TLogVAR ochars, llen
            " TLogVAR llen, alen, ochars, a:chars
            if llen == alen && ochars == a:chars
                let rv = 1
                break
            elseif llen > alen
                if ochars[0 : alen - 1] == a:chars
                    let rv = 0
                endif
            endif
        endif
    endfor
    " TLogVAR rv
    return rv
endf

