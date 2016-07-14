"=============================================================================
" Behaviors
"=============================================================================

"defaults
set number
set ruler
set ai
syntax on
set expandtab
set tabstop=2
set shiftwidth=2
set textwidth=80

"behaviors for ReStructuredText
augroup WrapLineInRST
  autocmd!
  autocmd FileType rst setlocal wrap
  autocmd FileType rst setlocal tabstop=3 shiftwidth=3 textwidth=80
augroup END


"=============================================================================
" Toggle highlighting of A/T in DNA/RNA sequences
"=============================================================================

highlight AT_HIGHLIGHT term=standout cterm=standout ctermfg=12 guifg=LightRed gui=bold

" toggle highlighting of AT
" after example at http://www.ibm.com/developerworks/linux/library/l-vim-script-1/index.html
function! ToggleAT()
  " safe toggle. 
  let w:toggle_at = exists("w:toggle_at") ? !w:toggle_at : 1
  
  if w:toggle_at
    match AT_HIGHLIGHT /[atuATU]/
  else
    match none
  endif

endfunction

" bind to AT key combination
nmap <silent> AT :call ToggleAT()<CR>


"=============================================================================
" Load external scripts
"=============================================================================


"see https://github.com/oblitum/rainbow/blob/master/plugin/rainbow.vimc 
let g:rainbow_active = 1
let g:rainbow_guifgs = ['RoyalBlue3', 'DarkOrange3', 'DarkOrchid3', 'FireBrick']
au VimEnter * RainbowLoad


" color scheme. see https://github.com/altercation/vim-colors-solarized
if has('gui_running')
  set background=light
  colorscheme solarized
endif


