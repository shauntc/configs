call plug#begin("~/.vim/plugged")
	" Plugin Section
	" Visual
	Plug 'tomasiser/vim-code-dark'
	Plug 'scrooloose/nerdtree'
	Plug 'Xuyuanp/nerdtree-git-plugin'
	Plug 'ryanoasis/vim-devicons'
	Plug 'itchyny/lightline.vim'
	Plug 'machakann/vim-highlightedyank'
	Plug 'andymass/vim-matchup'
	Plug 'zivyangll/git-blame.vim'
	Plug 'airblade/vim-gitgutter'
	" Functional
	Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all' }
	Plug 'junegunn/fzf.vim'
	Plug 'neoclide/coc.nvim', {'branch': 'release'}
	let g:coc_global_extensions = ['coc-emmet', 'coc-css', 'coc-html', 'coc-json', 'coc-tsserver', 'coc-rust-analyzer', 'coc-eslint']
	" Typescript
	Plug 'leafgarland/typescript-vim'
	Plug 'peitalin/vim-jsx-typescript'
	Plug 'cespare/vim-toml'
	Plug 'stephpy/vim-yaml'
	Plug 'rust-lang/rust.vim'
call plug#end()

" Config Section
if (has("termguicolors"))
	set termguicolors
endif
syntax enable
colorscheme codedark

let g:NERDTreeShowHidden = 1
let g:NERDTreeMinimalUI = 1
let g:NERDTreeIgnore = []
let g:NERDTreeStatusline = ''
autocmd vimenter * NERDTree " auto open nerdtree

" Automaticaly close nvim if NERDTree is only thing left open
autocmd bufenter * if (winnr("$") == 1 && exists("b:NERDTree") && b:NERDTree.isTabTree()) | q | endif
" Toggle
nnoremap <silent> <C-b> :NERDTreeToggle<CR>

" Map Ctrl-j and Ctrl-k to esc
nnoremap <C-j> <Esc>
inoremap <C-j> <Esc>
vnoremap <C-j> <Esc>
snoremap <C-j> <Esc>
xnoremap <C-j> <Esc>
cnoremap <C-j> <C-c>
onoremap <C-j> <Esc>
lnoremap <C-j> <Esc>
tnoremap <C-j> <Esc>

nnoremap <C-k> <Esc>
inoremap <C-k> <Esc>
vnoremap <C-k> <Esc>
snoremap <C-k> <Esc>
xnoremap <C-k> <Esc>
cnoremap <C-k> <C-c>
onoremap <C-k> <Esc>
lnoremap <C-k> <Esc>
tnoremap <C-k> <Esc>

" NeoVim Terminal
" open new split panes to right and below
set splitright
set splitbelow

set hidden
set tabstop=4 shiftwidth=4 expandtab

" turn terminal to normal mode with escape
tnoremap <Esc> <C-\><C-n>
" start terminal in insert mode
au BufEnter * if &buftype == 'terminal' | :startinsert | endif

" use alt+hjkl to move between split/vsplit panels
tnoremap <A-h> <C-\><C-n><C-w>h
tnoremap <A-j> <C-\><C-n><C-w>j
tnoremap <A-k> <C-\><C-n><C-w>k
tnoremap <A-l> <C-\><C-n><C-w>l
nnoremap <A-h> <C-w>h
nnoremap <A-j> <C-w>j
nnoremap <A-k> <C-w>k
nnoremap <A-l> <C-w>l

" Fuzzy Find
nnoremap <C-p> :FZF<CR>
let g:fzf_action = {
			\ 'ctrl-t': 'tab split',
			\ 'ctrl-s': 'split',
			\ 'alt-enter': 'vsplit'
			\}

" from http://sheerun.net/2014/03/21/how-to-boost-your-vim-productivity/
if executable('rg')
	set grepprg=rg\ --no-heading\ --vimgrep
	set grepformat=%f:%l:%c:%m
    let $FZF_DEFAULT_COMMAND='rg --files --no-ignore --hidden --follow --glob "!.git/*"'
elseif executable('ag')
    let $FZF_DEFAULT_COMMAND = 'ag -g ""'
	set grepprg=ag\ --nogroup\ --nocolor
endif

" Jump to end of line and begining of line
map H ^
map L $

" Lightline
let g:lightline = {
			\ 'active': {
			\   'left': [ [ 'mode', 'paste' ],
			\             [ 'cocstatus', 'readonly', 'filename', 'modified' ] ]
			\ },
			\ 'component_function': {
			\   'filename': 'LightlineFilename',
			\   'cocstatus': 'coc#status'
			\ },
			\ }
function! LightlineFilename()
	return expand('%:t') !=# '' ? @% : '[No Name]'
endfunction
" Force Lightline update
autocmd User CocStatusChange,CocDiagnosticChange call lightline#update()

" GUI Settings
set relativenumber
set number

" GoTo Code navigation
nmap <silent> gd <Plug>(coc-definition)
nmap <silent> gy <Plug>(coc-type-definition)
nmap <silent> gi <Plug>(coc-implementation)
nmap <silent> gr <Plug>(coc-references)

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

" Use K to show documentation in preview window.
nnoremap <silent> K :call <SID>show_documentation()<CR>

function! s:show_documentation()
	if (index(['vim','help'], &filetype) >= 0)
		execute 'h '.expand('<cword>')
	else
		call CocAction('doHover')
	endif
endfunction

" Git Blame
nnoremap <Leader>s :<C-u>call gitblame#echo()<CR>
