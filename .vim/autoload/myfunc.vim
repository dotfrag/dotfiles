" Toggle textwidth option
function! myfunc#ToggleTextWidth()
    if &textwidth
        setlocal textwidth=0
        echo "textwidth=0"
    else
        setlocal textwidth=80
        echo "textwidth=80"
    endif
endfunction

" Toggle conceallevel option
function! myfunc#ToggleConcealLevel()
    if &conceallevel
        setlocal conceallevel=0
        echo "conceallevel=0"
    else
        setlocal conceallevel=2
        echo "conceallevel=2"
    endif
endfunction

" Toggle paragraph mappings
let s:parmapstate=1
function! myfunc#ToggleParMappings()
    if s:parmapstate
        nnoremap <F4> gqap
        nnoremap <F5> g?ip
        nnoremap { {{)
        nnoremap } })
        echo "Paragraph mappings enabled"
    else
        unmap <F4>
        unmap <F5>
        unmap {
        unmap }
        echo "Paragraph mappings disabled"
    endif
    let s:parmapstate = !s:parmapstate
endfunction

" Center text between in a table
function! myfunc#CenterText()
    norm! 0
    let sp1 = searchpos('^\S*\zs\s', 'c')[1]
    let wd1 = searchpos('\S', 'z')[1]
    let sp2 = searchpos('\s\+\S\+$', 'zs')[1]
    let wd2 = searchpos('\s\zs\S', 'z')[1]
    let lm = wd1 - sp1
    let rm = wd2 - sp2
    let mm = abs(rm - lm) / 2
    if rm > lm
        exec 'norm! ' . sp2 . '|' . mm . 'x' . sp1 . '|p'
    elseif rm < lm
        let mm =  (mm == 0) ? 1 : mm
        exec 'norm! ' . sp2 . '|' . mm . "i \<ESC>" . sp1 . '|' . mm . 'x'
    endif
endfunction

" Visual Selection
function! myfunc#VisualSelection(direction, extra_filter) range
    let l:saved_reg = @"
    execute "normal! vgvy"
    let l:pattern = escape(@", "\\/.*'$^~[]")
    let l:pattern = substitute(l:pattern, "\n$", "", "")
    if a:direction == 'gv'
        call CmdLine("Ack '" . l:pattern . "' " )
    elseif a:direction == 'replace'
        call CmdLine("%s" . '/'. l:pattern . '/')
    endif
    let @/ = l:pattern
    let @" = l:saved_reg
endfunction

" Toggle Zen mode
let s:zenstate=1
function! myfunc#ZenMode()
    if s:zenstate
        execute 'Goyo'
        execute 'Limelight'
        echo "Zen mode enabled"
    else
        execute 'Goyo'
        execute 'Limelight!'
        echo "Zen mode disabled"
    endif
    let s:zenstate = !s:zenstate
endfunction
