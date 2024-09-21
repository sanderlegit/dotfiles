syntax on
set cmdheight=1

map <C-t> :tabe<CR>
map <silent> gt :tabe %<CR>

set autoread

nnoremap ∆ :m .+1<CR>==
nnoremap ˚ :m .-2<CR>==
inoremap ∆ <Esc>:m .+1<CR>==gi
inoremap ˚ <Esc>:m .-2<CR>==gi
vnoremap ∆ :m '>+1<CR>gv=gv
vnoremap ˚ :m '<-2<CR>gv=gv

set autoindent
set ts=4
filetype on

set ignorecase
set smartcase
set hlsearch
set modelines=0
set wildmenu
set wildmode=longest:full
set number "line numbers

"for indenting
set shiftwidth=4
set tabstop=4
set softtabstop=0 noexpandtab
set smarttab
vmap <Tab> >gv
vmap <S-Tab> <gv
inoremap <S-Tab> <C-D>

set nowrap
set mouse=a
set scrolloff=3 " keep three lines between the cursor and the edge of the screen
let mapleader = " " " Leader is the space key
let g:mapleader = " "

" easier write
nmap <leader>w :w!<cr>
" easier quit
nmap <leader>q :q<cr>
" silence search highlighting
nnoremap <leader>sh :nohlsearch<Bar>:echo<CR>

"paste from 0 register
nnoremap <A-l> :tabnext<CR>
nnoremap <A-h> :tabprevious<CR>

nnoremap K i<CR><Esc>

" persistent undo
if !isdirectory($HOME."/.dotfiles/vim/undodir")
    call mkdir($HOME."/.dotfiles/vim/undodir", "p")
endif

set undodir=~/.vim/undodir
set undofile
set undolevels=1000 "maximum number of changes that can be undone
set undoreload=10000 "maximum number lines to save for undo on a buffer reload

" Use ctrl-[hjkl] to select the active split!
nmap <silent> <c-k> :wincmd k<CR>
nmap <silent> <c-j> :wincmd j<CR>
nmap <silent> <c-h> :wincmd h<CR>
nmap <silent> <c-l> :wincmd l<CR>
