" basic vim settings

" open new split panes to right and below
set splitright
set splitbelow

set hidden

" start terminal in insert mode
autocmd BufEnter * if &buftype == 'terminal' | :startinsert | endif

" GUI Settings
set relativenumber
set number
