filetype off

call plug#begin('~/.vim/plugged')

" Better motion
Plug 'justinmk/vim-sneak'

" Pimped status line
Plug 'itchyny/lightline.vim'

" Color scheme and highlighter
Plug 'chuling/vim-equinusocio-material'
Plug 'chrisbra/Colorizer'

" git
Plug 'airblade/vim-gitgutter'
Plug 'tpope/vim-fugitive'

" Fuzzy search
Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
Plug 'junegunn/fzf.vim'

" Comment lines
Plug 'tpope/vim-commentary'

" C/CPP
Plug 'octol/vim-cpp-enhanced-highlight'
Plug 'rhysd/vim-clang-format'

" Syntax
Plug 'dart-lang/dart-vim-plugin'
Plug 'udalov/kotlin-vim'
Plug 'leafgarland/typescript-vim'

call plug#end()

if (has("termguicolors"))
 set termguicolors
endif

let g:equinusocio_material_darker = 1
colorscheme equinusocio_material

let mapleader = ','
syntax on

" General stuff
set nocompatible
set laststatus=2
set mouse=a
set backspace=2
set smartcase
set ruler
set scrolloff=4
set conceallevel=0
set textwidth=100

" Indentation
set tabstop=4
set shiftwidth=4
set expandtab
set cindent

" Search
set hlsearch
set incsearch
set ignorecase

" Undo
set undodir=~/.vim/undodir
set undofile
set undolevels=1000
set undoreload=10000

" Swaps
set backupdir=~/.vim/swaps
set directory=~/.vim/swaps

" Default statusline
set statusline=%<%F\ %h%m%r%=%-14.(%l,%c%V%)\ %P

set hidden
" Better display for messages
set cmdheight=2
" Smaller updatetime for CursorHold & CursorHoldI
set updatetime=100

" Set completeopt to have a better completion experience
set completeopt=menuone,noinsert,noselect

" Avoid showing message extra message when using completion
set shortmess+=c

" Tab completion. Taken from nvim-completion README.
function! s:check_back_space() abort
  let col = col('.') - 1
  return !col || getline('.')[col - 1] =~ '\s'
endfunction

inoremap <silent><expr> <TAB>
  \ pumvisible() ? "\<C-n>" :
  \ <SID>check_back_space() ? "\<TAB>" :
  \ completion#trigger_completion()

inoremap <silent><expr> <c-space> completion#trigger_completion()

" Highlight trailing whitespaces
highlight ExtraWhitespace ctermbg=red guibg=#FF4060
autocmd ColorScheme * highlight ExtraWhitespace ctermbg=red
autocmd InsertEnter * match ExtraWhiteSpace /\s\+\%#\@<!$/
autocmd InsertLeave * match ExtraWhiteSpace /\s\+$/

" Lightline
set noshowmode
let g:lightline = {
      \ 'colorscheme': 'equinusocio_material',
      \ 'active': {
      \   'left': [ [ 'mode', 'paste' ],
      \             [ 'gitbranch', 'readonly', 'relativepath', 'modified' ] ]
      \ },
      \ 'inactive': {
      \   'left': [ [ 'relativepath' ],
      \             [ ] ]
      \ },
      \ 'component_function': {
      \   'gitbranch': 'fugitive#head'
      \ }
      \ }

" CPP
autocmd FileType cpp setlocal shiftwidth=2 tabstop=2

" Makefiles should use tabulators
autocmd FileType make setlocal shiftwidth=4 tabstop=4 noexpandtab

" Logcat syntax files
autocmd BufRead,BufNewFile *.logcat setfiletype logcat

" Map that hard to type key
nmap ö [
nmap ä ]
omap ö [
omap ä ]
xmap ö [
xmap ä ]

" Navigation
nmap . .`[
nmap j gj
nmap k gk
nmap <c-j> :tjump 
nmap <c-h> :call SwitchSourceHeader() <CR>
nmap <F4> :e ~/.config/nvim/init.vim <CR>
nmap <F12> :tjump <C-R><C-W> <CR>
nmap <F12> :tjump <C-R><C-W> <CR>

" Fzf.vim
nnoremap <silent> <leader>f :Files <CR>
nnoremap <silent> <leader>b :Buffers <CR>
nnoremap <silent> <leader>j :GFiles <CR>
nnoremap <silent> <leader>t :Tags <CR>

" Quickfix/location
nnoremap qo :copen<CR>
nnoremap qc :cclose<CR>
nnoremap Lo :lopen<CR>
nnoremap Lc :lclose<CR>

" Diagnostics
nnoremap qn :NextDiagnosticCycle<CR>
nnoremap qp :PrevDiagnosticCycle<CR>

" override default f instead of s
map f <Plug>Sneak_s
map F <Plug>Sneak_S

" Generate new ctags for project
nmap <F8> :!ctags -R --c++-kinds=+p --fields=+ilaS --extras=+q+f .<CR>
nmap <C-F8> :!ctags -R --language-force=java --extras=+f --exclude=*.class .<CR>

" Change between indentation settings
nmap <F9> :set tabstop=4<CR>:set shiftwidth=4<CR>:set expandtab<CR>:set cinoptions=<CR>
nmap <F10> :set tabstop=2<CR>:set shiftwidth=2<CR>:set expandtab<CR>:set cinoptions=<CR>

" Magically fold from search result
nnoremap \z :setlocal foldexpr=(getline(v:lnum)=~@/)?0:(getline(v:lnum-1)=~@/)\\|\\|(getline(v:lnum+1)=~@/)?1:2 foldmethod=expr foldlevel=0 foldcolumn=2<CR>

"Added ! to overwrite on reload
function! SwitchSourceHeader()
    let extension = expand("%:e")
    if extension ==? "cpp" || extension ==? "c"
        let extension = ".h"
    else
        let extension = ".c"
    endif
    let file = expand("%:t:r").extension
    if bufexists(bufname(file))
        execute "buffer ".file
    else
        execute "tjump ".file
    endif
endfunction

" clang-format
let g:clang_format#detect_style_file = 1
let g:clang_format#style_options = { "Standard" : "C++11" }
autocmd FileType c,cpp,objc nnoremap <buffer><Leader>cf :<C-u>ClangFormat<CR>
autocmd FileType c,cpp,objc vnoremap <buffer><Leader>cf :ClangFormat<CR>
autocmd FileType typescript noremap <buffer><Leader>cf :ClangFormat<cr>

