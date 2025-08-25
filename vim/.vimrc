" Basics
set nocompatible              " Disable Vi compatibility
filetype plugin indent on    " Enable file type detection and plugins
syntax enable                 " Enable syntax highlighting

" Display
set number                    " Show line numbers
set cursorline               " Highlight current line
set showmatch                " Show matching brackets
set laststatus=2             " Always show status line
set ruler                    " Show cursor position
set showcmd                  " Show command in status line
set wildmenu                 " Enhanced command line completion
set wildmode=longest:full,full " Command line completion mode

" Indentation and Formatting
set autoindent               " Auto-indent new lines
set smartindent              " Smart indenting for code
set tabstop=4                " Tab width
set softtabstop=4            " Tab width when editing
set shiftwidth=4             " Indent width
set expandtab                " Use spaces instead of tabs
set smarttab                 " Smart tab handling
set wrap                     " Enable line wrapping
set linebreak                " Break lines at word boundaries
set textwidth=80             " Line length limit

" Search
set hlsearch                 " Highlight search results
set incsearch                " Incremental search
set ignorecase               " Case-insensitive search
set smartcase                " Case-sensitive if uppercase letters present

" Performance?
set hidden                   " Allow switching buffers without saving
set mouse=a                  " Enable mouse support
set clipboard=unnamedplus    " Use system clipboard (Linux/WSL)
set backspace=indent,eol,start " Fix backspace behavior
set scrolloff=5              " Keep 5 lines visible when scrolling
set sidescrolloff=5          " Keep 5 columns visible when scrolling
set history=1000             " Command history size
set undolevels=1000          " Undo history size

" File Handling
set autoread                 " Automatically reload changed files
set backup                   " Keep backup files
set backupdir=~/.vim/backup  " Backup directory
set directory=~/.vim/swp     " Swap file directory
set undofile                 " Persistent undo
set undodir=~/.vim/undo      " Undo directory


colorscheme peachpuff

highlight LineNr ctermfg=gray
highlight CursorLine cterm=NONE ctermbg=darkgray
highlight Search ctermbg=yellow ctermfg=black
highlight Visual ctermbg=blue ctermfg=white

" Mappings
let mapleader = " "

" Quick save and quit
nnoremap <leader>w :w<CR>
nnoremap <leader>q :q<CR>
nnoremap <leader>x :x<CR>

" Clear search highlighting
nnoremap <leader>/ :nohlsearch<CR>

" Buffer navigation
nnoremap <leader>n :bnext<CR>
nnoremap <leader>p :bprev<CR>
nnoremap <leader>d :bdelete<CR>

" Split windows
nnoremap <leader>v :vsplit<CR>
nnoremap <leader>h :split<CR>

" Navigate Vsplits
nnoremap <leader><left> :<C-w><left>
nnoremap <leader><right> :<C-w><right>

" Indentation in visual mode
vnoremap < <gv
vnoremap > >gv

" Toggle line numbers
nnoremap <leader>l :set nu!<CR>

" Enable built-in file explorer enhancements
let g:netrw_banner = 0        " Remove banner
let g:netrw_liststyle = 3     " Tree style listing
let g:netrw_winsize = 25      " 25% width for explorer

" File explorer shortcut
nnoremap <leader>e :Explore<CR>

set statusline=%f             " File path
set statusline+=%m            " Modified flag
set statusline+=%r            " Read-only flag
set statusline+=%h            " Help flag
set statusline+=%w            " Preview flag
set statusline+=%=            " Right align
set statusline+=[%{&ff}]      " File format
set statusline+=[%Y]          " File type
set statusline+=[%p%%]        " Percentage through file
set statusline+=[%l/%L:%c]    " Line/total:column

" Auto Commands
if has('autocmd')
    " Create backup/swap/undo directories if they don't exist
    augroup directories
        autocmd!
        autocmd VimEnter * if !isdirectory($HOME.'/.vim/backup') | call mkdir($HOME.'/.vim/backup', 'p') | endif
        autocmd VimEnter * if !isdirectory($HOME.'/.vim/swp') | call mkdir($HOME.'/.vim/swp', 'p') | endif
        autocmd VimEnter * if !isdirectory($HOME.'/.vim/undo') | call mkdir($HOME.'/.vim/undo', 'p') | endif
    augroup END

    augroup filetype_settings
        autocmd!
        " Python
        autocmd FileType python setlocal tabstop=4 shiftwidth=4 expandtab
        " JavaScript/html/css/json
        autocmd FileType javascript,html,css,json setlocal tabstop=2 shiftwidth=2 expandtab
        " YAML
        autocmd FileType yaml setlocal tabstop=2 shiftwidth=2 expandtab
        " Markdown
        autocmd FileType markdown setlocal wrap linebreak textwidth=80
        " Remove trailing whitespace on save
        autocmd BufWritePre * :%s/\s\+$//e
    augroup END

    " Return to last edit position when opening files
    augroup return_cursor
        autocmd!
        autocmd BufReadPost * if line("'\"") > 0 && line("'\"") <= line("$") | exe "normal! g`\"" | endif
    augroup END
endif
