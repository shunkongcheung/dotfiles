" VIM DEFAULT CONFIGURATIONS =================================================

" When a file has been detected to have been changed outside of Vim and
" it has not been changed inside of Vim, automatically read it again
set autoread

" default input settings
set backspace=1
set shiftwidth=2
set tabstop=2

" numbering on the right with relative numbers
set number
set relativenumber

" color scheme: highlight matching closure
set showmatch

" color scheme: hightlight searching when you type the first character of the search string
set incsearch
set nohlsearch

" file system: nertree setting. tree list style
let g:netrw_altv=1
let g:netrw_liststyle=3
let g:netrw_banner=0
let g:netrw_browse_split = 4
let g:netrw_list_hide= '.*\.swp$,.*\.pyc'
autocmd FileType netrw setl bufhidden=wipe
let g:netrw_bufsettings = 'noma nomod nu nobl nowrap ro'

let g:NetrwIsOpen=0

function! ToggleNetrw()
    if g:NetrwIsOpen
        let i = bufnr("$")
        while (i >= 1)
            if (getbufvar(i, "&filetype") == "netrw")
                silent exe "bwipeout " . i
            endif
            let i-=1
        endwhile
        let g:NetrwIsOpen=0
    else
        let g:NetrwIsOpen=1
        silent Lexplore | vertical resize 40
    endif
endfunction

" Add your own mapping. For example:
noremap <silent> gx :call ToggleNetrw()<CR>

" file system: spliting to the right side
set splitright

" file system: find in command mode. Tab to autocomplete filename
set path+=**
set wildmenu

" folding
set nofoldenable

" plugins: file type
filetype plugin on

set encoding=utf-8  " The encoding displayed.
set fileencoding=utf-8  " The encoding written to file.
scriptencoding utf-8


" if hidden is not set, TextEdit might fail.
set hidden

" Some servers have issues with backup files, see #649
set nobackup
set nowritebackup

" Better display for messages
set cmdheight=2

" You will have bad experience for diagnostic messages when it's default 4000.
set updatetime=300

" for searching visually selected word
vnoremap // y/\V<C-R>=escape(@",'/\')<CR><CR>

" PLUGINS CONFIGURATION ======================================================
" Specify a directory for plugins
" - For Neovim: ~/.local/share/nvim/plugged
" - Avoid using standard Vim directory names like 'plugin'
call plug#begin('~/.vim/plugged')
	" language server for code completion
	Plug 'neoclide/coc.nvim', {'branch': 'release'}

  	" theme
  	Plug 'joshdick/onedark.vim'

	" commenting
	Plug 'tpope/vim-commentary'
	Plug 'jbgutierrez/vim-better-comments'

	" editor configuration
	Plug 'editorconfig/editorconfig-vim'

	" syntax hiehglihting
	Plug 'sheerun/vim-polyglot'

	Plug 'vim-airline/vim-airline'
	Plug 'vim-airline/vim-airline-themes'

  	" git
  	Plug 'tpope/vim-fugitive'
	
	" =========================================================

call plug#end()

" color scheme: theme
syntax on
colorscheme onedark
let g:airline_theme='simple'

" movement
nnoremap <silent> gw <C-w>
nnoremap <silent> gj <C-d>
nnoremap <silent> gk <C-u>

" coc
" Use <c-space> to trigger completion.
inoremap <silent><expr> <c-space> coc#refresh()

" Use `[g` and `]g` to navigate diagnostics
nmap <silent> [g <Plug>(coc-diagnostic-prev)
nmap <silent> ]g <Plug>(coc-diagnostic-next)

" Remap keys for gotos
nmap <silent> gd <Plug>(coc-definition)
nmap <silent> gy <Plug>(coc-type-definition)
nmap <silent> gi <Plug>(coc-implementation)
nmap <silent> gr <Plug>(coc-references)

" Use K to show documentation in preview window
function! s:show_documentation()
  if (index(['vim','help'], &filetype) >= 0)
    execute 'h '.expand('<cword>')
  elseif (coc#rpc#ready())
    call CocActionAsync('doHover')
  else
    execute '!' . &keywordprg . " " . expand('<cword>')
  endif
endfunction
nnoremap <silent> K :call <SID>show_documentation()<CR>

let g:coc_global_extensions=['coc-tsserver', 'coc-eslint', 'coc-prettier']

function! s:git_ignore_check()
    let pathstring = ''
    let igstring = ''

    " all files in current directory, non-recursive
    for filename in split(globpath('.', '*'), '\n')
        let isdir = isdirectory(filename)
        let should_ignore = 0

        " convert .\DirName into DirName"
        " when path=.\DirName\**, running :find Filename wont show file at path .\DirName\SubDir\Filename.txt
        " when path=DirName\**, running :find Filename will show file at path .\DirName\SubDir\Filename.txt
        let filename_better = substitute(filename, '.\\', '', 'g') 
        if isdir == 1
            " running it on Windows. For Linux/Mac, might use '/**' instead
            let filename_better .= '\\**'
        endif

        if isdir == 1
            " only run git check-ignore for directory
            let gitignore_command = "git check-ignore " . filename
            if system(gitignore_command) != ""
                let should_ignore = 1
            endif
        endif

        if should_ignore
            let igstring .= ',' . filename_better
        else
            let pathstring .= ',' . filename_better
        endif
    endfor
    execute "set wildignore+=".substitute(igstring, '^,', '', "g")
    execute  "set path=".pathstring
endfunction

" hit capital H to run on current directory
nnoremap <silent> H :call <SID>git_ignore_check()<CR>
