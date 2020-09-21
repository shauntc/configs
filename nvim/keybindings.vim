"** KEY REMAPPING **"
" Map Ctrl-j and Ctrl-k to esc
nnoremap <C-Space> <Esc>
inoremap <C-Space> <Esc>
vnoremap <C-Space> <Esc>
snoremap <C-Space> <Esc>
xnoremap <C-Space> <Esc>
cnoremap <C-Space> <C-c>
onoremap <C-Space> <Esc>
lnoremap <C-Space> <Esc>
tnoremap <C-Space> <Esc>

" use alt+hjkl to move between split/vsplit panels
tnoremap <A-h> <C-\><C-n><C-w>h
tnoremap <A-j> <C-\><C-n><C-w>j
tnoremap <A-k> <C-\><C-n><C-w>k
tnoremap <A-l> <C-\><C-n><C-w>l
nnoremap <A-h> <C-w>h
nnoremap <A-j> <C-w>j
nnoremap <A-k> <C-w>k
nnoremap <A-l> <C-w>l

" turn terminal to normal mode with escape
tnoremap <Esc> <C-\><C-n>

" map Ctrl hjkl for jumping around
map <C-l> w
map <C-k> <C-y><bar>k
map <C-j> <C-e><bar>j
map <C-h> b
map <S-Space> 10<C-e><bar>10j

" Jump to end of line and begining of line
map H ^
map L $

" GoTo Code navigation
nmap <silent> gd <Plug>(coc-definition)
nmap <silent> gy <Plug>(coc-type-definition)
nmap <silent> gi <Plug>(coc-implementation)
nmap <silent> gr <Plug>(coc-references)

" Go to error
map E :call CocAction('diagnosticNext')<CR>

" Ctrl+s for save
map <C-s> :w<CR>
map! <C-s> <ESC>:w<CR>

" Use K to show documentation in preview window.
nnoremap <silent> K :call <SID>show_documentation()<CR>

function! s:show_documentation()
    if (index(['vim','help'], &filetype) >= 0)
        execute 'h '.expand('<cword>')
    else
        call CocAction('doHover')
    endif
endfunction

" Use tab for trigger completion with characters ahead and navigate.
" " NOTE: Use command ':verbose imap <tab>' to make sure tab is not mapped by
" " other plugin before putting this into your config.
inoremap <silent><expr> <TAB>
      \ pumvisible() ? "\<C-n>" :
      \ <SID>check_back_space() ? "\<TAB>" :
      \ coc#refresh()
inoremap <expr><S-TAB> pumvisible() ? "\<C-p>" : "\<C-h>"

function! s:check_back_space() abort
	let col = col('.') - 1
	return !col || getline('.')[col - 1]  =~# '\s'
endfunction

" Git Blame
nnoremap <Leader>s :<C-u>call gitblame#echo()<CR>

"** END KEY REMAPPING **"
