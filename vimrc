"=============================================================================
" Behaviors
"=============================================================================

"defaults
set backspace=indent,eol,start
set number
set ruler
set autoindent
set showcmd
set expandtab
set tabstop=4
set shiftwidth=4
set textwidth=80
syntax on

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
  set guifont=Monospace\ 8
  colorscheme solarized
endif



"" requires rainbowpares
"au VimEnter * RainbowParenthesesToggle
"au Syntax * RainbowParenthesesLoadRound
"au Syntax * RainbowParenthesesLoadSquare
"au Syntax * RainbowParenthesesLoadBraces



" Other boilerplate

" Only do this part when compiled with support for autocommands.
if has("autocmd")

  " Enable file type detection.
  " Use the default filetype settings, so that mail gets 'tw' set to 72,
  " 'cindent' is on in C files, etc.
  " Also load indent files, to automatically do language-dependent indenting.
  filetype plugin indent on

  " Put these in an autocmd group, so that we can delete them easily.
  augroup vimrcEx
  au!

  " For all text files set 'textwidth' to 78 characters.
  autocmd FileType text setlocal textwidth=78

  augroup END

else

  set autoindent		" always set autoindenting on

endif " has("autocmd")
