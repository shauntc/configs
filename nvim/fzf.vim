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
