"=============================================================================
" Vundle & plugin config
"=============================================================================

" set up
set nocompatible  " be iMproved, required
filetype off      " required

" set the runtime path to include Vundle and initialize
set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()


" let Vundle manage Vundle, required
Plugin 'VundleVim/Vundle.vim'

" others
Plugin 'vim-airline/vim-airline'
Plugin 'vim-airline/vim-airline-themes'
Plugin 'airblade/vim-gitgutter'
Plugin 'godlygeek/tabular'
Plugin 'eapache/rainbow_parentheses.vim'
Plugin 'altercation/vim-colors-solarized'
Plugin 'tpope/vim-fugitive'
Plugin 'Valloric/YouCompleteMe'
Plugin 'google/yapf'


" All of your Plugins must be added before the following line
call vundle#end()            " required
filetype plugin indent on    " required


" solarized
if has('gui_running')
  set background=dark
  set guifont=Ubuntu\ Mono\ derivative\ Powerline\ 10
  set guioptions-=T
  colorscheme solarized
endif
let g:solarized_contrast='high'


" gitgutter
set updatetime=250
"let g:gitgutter_highlight_lines = 1


" airline
let g:airline#extensions#tabline#enabled = 1
let g:airline_powerline_fonts = 1
let g:airline_theme='light' " molokai, wombat, tomorrow, solarized
set laststatus=2


" yapf
map <C-Y> :call yapf#YAPF()<cr>
imap <C-Y> <c-o> :call yapf#YAPF()<cr>


" rainbow parens
au VimEnter * RainbowParenthesesToggle
au VimEnter * RainbowParenthesesLoadRound
au VimEnter * RainbowParenthesesLoadSquare
au VimEnter * RainbowParenthesesLoadBraces
au VimEnter * RainbowParenthesesLoadChevrons


" youcompleteme
let g:ycm_goto_buffer_command = 'horiontal-split'
let g:ycm_filepath_completion_use_working_dir = 1
nmap <silent> <C-Y> <C-D> :YcmCompleter GoTo<CR>
nmap <silent> <C-Y> <C-R> :YcmCompleter GoToReferences<CR>



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
set listchars=eol:¬,tab:▸·,trail:·
set hlsearch "highlight search results
set colorcolumn=80,100
"set textwidth=80
syntax on


"show whitespace characters for python files
augroup PythonFile    
  autocmd!
  autocmd FileType python
;  autocmd FileType python setlocal list
augroup END


"behaviors for ReStructuredText
augroup WrapLineInRST
  autocmd!
  autocmd FileType rst setlocal spell
  autocmd FileType rst setlocal wrap
  autocmd FileType rst setlocal tabstop=3 shiftwidth=3 textwidth=80
"  autocmd FileType rst SpellCheck
augroup END


"=============================================================================
" Misc funcs
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
" Other boilerplate
"=============================================================================

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
