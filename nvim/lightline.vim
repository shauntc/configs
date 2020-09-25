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

