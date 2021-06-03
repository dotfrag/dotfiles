nmap <buffer> gor  :UpdateFile<cr><Plug>(go-run)
nmap <buffer> <F5> :UpdateFile<cr><Plug>(go-run)

nmap <buffer> gof <Plug>(go-rename)
nmap <buffer> god <Plug>(go-def-split)
nmap <buffer> goD <Plug>(go-doc)

nmap <buffer> goi :UpdateFile<cr><Plug>(go-imports)
nmap <buffer> got :UpdateFile<cr><Plug>(go-test)
nmap <buffer> gol :UpdateFile<cr><Plug>(go-lint)
nmap <buffer> gov :UpdateFile<cr><Plug>(go-vet)

nmap <buffer> gom :UpdateFile<cr><Plug>(go-metalinter)
