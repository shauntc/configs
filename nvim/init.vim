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
    Plug 'tpope/vim-sleuth' " Automagically set tab size
    " Language Server
    Plug 'neoclide/coc.nvim', {'branch': 'release'}
    let g:coc_global_extensions = ['coc-emmet', 'coc-css', 'coc-html', 'coc-json', 'coc-tsserver', 'coc-rust-analyzer', 'coc-eslint']
    " Typescript
    Plug 'leafgarland/typescript-vim'
    Plug 'peitalin/vim-jsx-typescript'
    Plug 'cespare/vim-toml'
    Plug 'stephpy/vim-yaml'
    Plug 'rust-lang/rust.vim'
    Plug 'dag/vim-fish'
call plug#end()

""" Colors!
if (has("termguicolors"))
    set termguicolors
endif
syntax enable
colorscheme codedark
"" END COLORS!

let g:NERDTreeShowHidden = 1
let g:NERDTreeMinimalUI = 1
let g:NERDTreeIgnore = []
let g:NERDTreeStatusline = ''
let g:NERDTreeGitStatusShowIgnored = 1 " a heavy feature may cost much more time. default: 0
autocmd vimenter * NERDTree " auto open nerdtree

" Automaticaly close nvim if NERDTree is only thing left open
autocmd bufenter * if (winnr("$") == 1 && exists("b:NERDTree") && b:NERDTree.isTabTree()) | q | endif
" Toggle
nnoremap <silent> <C-b> :NERDTreeToggle<CR>

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

" Use <cr> to confirm completion, `<C-g>u` means break undo chain at current
" " position. Coc only does snippet and additional edit on confirm.
" " <cr> could be remapped by other vim plugin, try `:verbose imap <CR>`.
if exists('*complete_info')
    inoremap <expr> <cr> complete_info()["selected"] != "-1" ? "\<C-y>" : "\<C-g>u\<CR>"
else
    inoremap <expr> <cr> pumvisible() ? "\<C-y>" : "\<C-g>u\<CR>"
endif
" NeoVim Terminal
" open new split panes to right and below
set splitright
set splitbelow

set hidden

" start terminal in insert mode
autocmd BufEnter * if &buftype == 'terminal' | :startinsert | endif

" Fuzzy Find
nnoremap <C-p> :FZF<CR>
let g:fzf_action = {
			\ 'ctrl-t': 'tab split',
			\ 'ctrl-s': 'split',
			\ 'alt-enter': 'vsplit'
			\}

" Use ripgrep or ag if installed
if executable('rg')
	set grepprg=rg\ --no-heading\ --vimgrep
	set grepformat=%f:%l:%c:%m
    let $FZF_DEFAULT_COMMAND='rg --files --no-ignore --hidden --follow --glob "!.git/*"'
elseif executable('ag')
    let $FZF_DEFAULT_COMMAND = 'ag -g ""'
	set grepprg=ag\ --nogroup\ --nocolor
endif

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


