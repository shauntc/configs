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
    Plug 'junegunn/fzf',
    Plug 'junegunn/fzf.vim'
    Plug 'tpope/vim-sleuth' " Automagically set tab size
    " Language Server
    Plug 'neoclide/coc.nvim', {'branch': 'release'}
    let g:coc_global_extensions = ['coc-emmet', 'coc-css', 'coc-html', 'coc-json', 'coc-tsserver', 'coc-rust-analyzer', 'coc-eslint', 'coc-powershell', 'coc-snippets']
    Plug 'sheerun/vim-polyglot'
    " Typescript
    Plug 'leafgarland/typescript-vim'
    Plug 'peitalin/vim-jsx-typescript'
    Plug 'cespare/vim-toml'
    Plug 'stephpy/vim-yaml'
    Plug 'rust-lang/rust.vim'
    Plug 'dag/vim-fish'
call plug#end()
