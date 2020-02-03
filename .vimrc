set nocompatible              " be iMproved, required
filetype off                  " required

" set the runtime path to include Vundle and initialize
set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()
" alternatively, pass a path where Vundle should install plugins
"call vundle#begin('~/some/path/here')

" let Vundle manage Vundle, required
" Plugin 'Valloric/YouCompleteMe'

" All of your Plugins must be added before the following line
Plugin	'sheerun/vim-polyglot'
    "syntax completer
Plugin	'joshdick/onedark.vim'
    "theme
Plugin	'itchyny/lightline.vim'
    "bottom status bar
Plugin	'junegunn/fzf'
    "search tool? not sure if installed correctly
Plugin	'junegunn/fzf.vim'
    "extra commands
Plugin	'frazrepo/vim-rainbow'
    "rainbow brackets
Plugin	'preservim/nerdtree'
    "file browser
Plugin	'preservim/nerdcommenter'
    "commenting tool
Plugin	'jiangmiao/auto-pairs'
    " bracket pairing
Plugin	'airblade/vim-gitgutter'
    " git edit status on side
Plugin	'ryanoasis/vim-devicons'
    " fonts and icon support for nerdtree
Plugin	'ycm-core/YouCompleteMe'
    " syntax completion
call vundle#end()            " required
filetype plugin indent on    " required

" onedark
"Use 24-bit (true-color) mode in Vim/Neovim when outside tmux.
"If you're using tmux version 2.2 or later, you can remove the outermost $TMUX check and use tmux's 24-bit color support
"(see < http://sunaku.github.io/tmux-24bit-color.html#usage > for more information.)
if (empty($TMUX))
  if (has("nvim"))
    "For Neovim 0.1.3 and 0.1.4 < https://github.com/neovim/neovim/pull/2198 >
    let $NVIM_TUI_ENABLE_TRUE_COLOR=1
  endif
  "For Neovim > 0.1.5 and Vim > patch 7.4.1799 < https://github.com/vim/vim/commit/61be73bb0f965a895bfb064ea3e55476ac175162 >
  "Based on Vim patch 7.4.1770 (`guicolors` option) < https://github.com/vim/vim/commit/8a633e3427b47286869aa4b96f2bfc1fe65b25cd >
  " < https://github.com/neovim/neovim/wiki/Following-HEAD#20160511 >
  if (has("termguicolors"))
    set termguicolors
  endif
endif

syntax on
colorscheme onedark

" vim-rainbow
let g:rainbow_active = 1

" nerdtree
map <C-n> :NERDTreeToggle<CR>

" nerdcommenter
filetype plugin on

" everything below here was from the downloaded .vimrc
set autoindent
set ts=4
filetype on

syntax on
set ignorecase
set smartcase
set hlsearch
set modelines=0
set wildmenu
set wildmode=longest:full
set nu "line numbers

"for indenting
set expandtab
set shiftwidth=4
set tabstop=4
set smarttab
vmap <Tab> >gv
vmap <S-Tab> <gv
inoremap <S-Tab> <C-D>

set lbr "word wrap
set tw=500

set wrap "Wrap lines

" scrolling
inoremap <C-E> <C-X><C-E> "scrolling on insert
inoremap <C-Y> <C-X><C-Y>
set scrolloff=3 " keep three lines between the cursor and the edge of the screen

" With a map leader it's possible to do extra key combinations
" like <leader>w saves the current file
let mapleader = " " " Leader is the space key
let g:mapleader = " "
"auto indent for brackets
inoremap {<CR> {<CR>}<Esc>O
" easier write
nmap <leader>w :w!<cr>
" easier quit
nmap <leader>q :q<cr>
" silence search highlighting
nnoremap <leader>sh :nohlsearch<Bar>:echo<CR>
"paste from outside buffer
nnoremap <leader>p :set paste<CR>"+p:set nopaste<CR>
vnoremap <leader>p <Esc>:set paste<CR>gv"+p:set nopaste<CR>
"copy to outside buffer
vnoremap <leader>y "+y
"select all
nnoremap <leader>a ggVG
"paste from 0 register
"Useful because `d` overwrites the <quote> register
nnoremap <leader>P "0p
vnoremap <leader>P "0p

nnoremap <C-l> :tabnext<CR>
nnoremap <C-h> :tabprevious<CR>

"nnoremap tj  :tabnext<CR>

set mouse=a

" move in long lines
nnoremap k gk
nnoremap j gj

" vimslime
"let g:slime_target = "tmux"
"nmap <C-C><C-N> :set ft=haskell.script<CR><C-C><C-C>:set ft=haskell<CR>

" persistent undo
if !isdirectory($HOME."/.dotfiles/vim/undodir")
    call mkdir($HOME."/.dotfiles/vim/undodir", "p")
endif

set undodir=~/.vim/undodir
set undofile
set undolevels=1000 "maximum number of changes that can be undone
set undoreload=10000 "maximum number lines to save for undo on a buffer reload

" vp doesn't replace paste buffer
function! RestoreRegister()
  let @" = s:restore_reg
  return ''
endfunction
function! s:Repl()
  let s:restore_reg = @"
  return "p@=RestoreRegister()\<cr>"
endfunction
vmap <silent> <expr> p <sid>Repl()

" markdown also starts with .md
autocmd BufNewFile,BufRead *.md set filetype=markdown

" fzf command
set rtp+=~/.fzf

nnoremap <leader>t :call fzf#run({ 'sink': 'tabe', 'options': '-m +c', 'dir': '.', 'source': 'find .' })<CR>

" ctags looks in the right directory
set tags=./.tags,.tags;$HOME
nnoremap <C-}> g<C-]>
nnoremap <C-[> <C-t>


" Run python when typing <leader>r
noremap <buffer> <leader>r :w<cr> :exec '!python' shellescape(@%, 1)<cr>

"ycm
"let g:ycm_global_ycm_extra_conf = '~/.dotfiles/vim/bundle/YouCompleteMe/.ycm_extra_conf.py'
"let g:ycm_confirm_extra_conf = 0 " Don't ask for confirmation about ycm_extra_conf
"
" From http://stackoverflow.com/questions/3105307/how-do-you-automatically-remove-the-preview-window-after-autocompletion-in-vim
" If you prefer the Omni-Completion tip window to close when a selection is
" made, these lines close it on movement in insert mode or when leaving
" insert mode
"autocmd CursorMovedI * if pumvisible() == 0|pclose|endif
autocmd InsertLeave * if pumvisible() == 0|pclose|endif

" Red coloring at whitespace after end of line whitespace
autocmd InsertEnter * syn clear EOLWS | syn match EOLWS excludenl /\s\+\%#\@!$/
autocmd InsertLeave * syn clear EOLWS | syn match EOLWS excludenl /\s\+$/
highlight EOLWS ctermbg=red guibg=red
