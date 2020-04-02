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

" " file system: nertree setting. tree list style
" let g:netrw_altv=1
" let g:netrw_liststyle=3
" let g:netrw_banner=0
" let g:netrw_list_hide= '.*\.swp$,.*\.pyc'
" autocmd FileType netrw setl bufhidden=wipe
" let g:netrw_bufsettings = 'noma nomod nu nobl nowrap ro'

" " file system: spliting to the right side
" set splitright

" " open up Lexplore on startsup
" autocmd VimEnter * Lexplore | vertical resize 40

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

" ============================================================================

" PLUGINS CONFIGURATION ======================================================
" Specify a directory for plugins
" - For Neovim: ~/.local/share/nvim/plugged
" - Avoid using standard Vim directory names like 'plugin'
call plug#begin('~/.vim/plugged')
	Plug 'vifm/vifm.vim'

	" language server for code completion
	Plug 'neoclide/coc.nvim', {'branch': 'release'}

	" color scheme
	Plug 'joshdick/onedark.vim'

	" commenting
	Plug 'tpope/vim-commentary'
	Plug 'jbgutierrez/vim-better-comments'

	" git plugin
	Plug 'tpope/vim-fugitive'

	" asynchronous linting engine
	Plug 'dense-analysis/ale'

	" editor configuration
	Plug 'editorconfig/editorconfig-vim'

	" snippet
	Plug 'SirVer/ultisnips'

	" syntax hiehglihting
	Plug 'sheerun/vim-polyglot'

	Plug 'vim-airline/vim-airline'
	Plug 'vim-airline/vim-airline-themes'
	" Plug 'edkolev/tmuxline.vim'

	" =========================================================

call plug#end()


" ================= COMMON ================================

" asynchronous linting engine
let g:ale_fixers = {
\   '*': ['remove_trailing_lines', 'trim_whitespace'],
\   'css': ['prettier'],
\   'scss': ['prettier'],
\   'javascript': ['prettier', 'eslint'],
\   'typescript': ['prettier', 'eslint'],
\   'vue': ['prettier', 'eslint'],
\ 	'python': ['autopep8',  'yapf'],
\}
let b:ale_linters = ['flake8', 'pylint', 'eslint']
let g:ale_fix_on_save = 1
let g:ale_python_flake8_executable = 'python3'   " or 'python' for Python 2
let g:ale_sign_warning = '.'

highlight ALEError ctermbg=DarkMagenta
highlight ALEWarning ctermbg=Grey

" color scheme: theme
syntax on
colorscheme onedark
hi Directory ctermfg=Yellow
hi LineNr ctermfg=DarkGrey
hi MatchParen cterm=bold ctermbg=none ctermfg=magenta
hi Normal guibg=NONE ctermbg=NONE
hi Comment ctermfg=99AA00
hi CursorLineNr ctermfg=Yellow

" vim-fugitive setting
set diffopt+=vertical
highlight DiffAdd    cterm=bold ctermfg=10 ctermbg=17 gui=none guifg=bg guibg=Red
highlight DiffDelete cterm=bold ctermfg=10 ctermbg=17 gui=none guifg=bg guibg=Red
highlight DiffChange cterm=bold ctermfg=10 ctermbg=17 gui=none guifg=bg guibg=Red
highlight DiffText   cterm=bold ctermfg=10 ctermbg=88 gui=none guifg=bg guibg=Red

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
let g:coc_user_config = {}
let g:coc_user_config['coc.preferences.jumpCommand'] = 'split'

" Use K to show documentation in preview window
nnoremap <silent> K :call <SID>show_documentation()<CR>

function! s:show_documentation()
  if (index(['vim','help'], &filetype) >= 0)
    execute 'h '.expand('<cword>')
  else
    call CocAction('doHover')
  endif
endfunction

" vim-airline
"" remove the filetype part
let g:airline_section_x=''

" vifm key binding
nmap <silent> vv :VsplitVifm<CR>
nmap <silent> vs :SplitVifm<CR>

" =========================================================

" ================= JAVASCRIPT ============================

" MatchTagAlways settings
let g:mta_use_matchparen_group = 1
let g:mta_filetypes = {
    \ 'html' : 1,
    \ 'javascript' : 1,
    \ 'typescript' : 1,
    \ 'typescript.tsx' : 1,
    \ 'javascript.jsx' : 1,
    \}
let g:mta_use_matchparen_group = 1
highlight MatchTag ctermfg=black ctermbg=lightgreen guifg=black guibg=lightgreen
nnoremap <leader>% :MtaJumpToOtherTag<cr>

" set filetypes as typescript.tsx
autocmd BufNewFile,BufRead *.tsx,*.jsx set filetype=typescript.tsx
autocmd FileType typescript.tsx setlocal commentstring=//\ %s

" =========================================================

" ================= PYTHON ================================
let g:python_highlight_all = 1
let g:python_version_2 = 1

au FileType python highlight Comment cterm=bold
"python with virtualenv support
" py3 << EOF
" import os
" import sys
" if 'VIRTUAL_ENV' in os.environ:
"   project_base_dir = os.environ['VIRTUAL_ENV']
"   activate_this = os.path.join(project_base_dir, 'bin/activate_this.py')
"   execfile(activate_this, dict(__file__=activate_this))
" EOF
" =========================================================
