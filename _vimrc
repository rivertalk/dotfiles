set nocompatible              " be iMproved, required
filetype off                  " required

call plug#begin('~/.vim/plugged')

Plug 'majutsushi/tagbar'
Plug 'scrooloose/nerdtree'
Plug 'tpope/vim-surround'
Plug 'scrooloose/nerdcommenter'
Plug 'godlygeek/tabular'
Plug 'bling/vim-airline'
Plug 'vim-airline/vim-airline-themes'
Plug 'nathanaelkane/vim-indent-guides'
Plug 'jlanzarotta/bufexplorer'

" tool integration
Plug 'rking/ag.vim'
Plug 'tpope/vim-fugitive'
Plug 'nfvs/vim-perforce'
Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
Plug 'junegunn/fzf.vim'

" enhanced highlight
Plug 'plasticboy/vim-markdown'
Plug 'antiagainst/vim-tablegen'

" color scheme
Plug 'altercation/vim-colors-solarized'
Plug 'sickill/vim-monokai'
Plug 'dracula/vim', { 'as': 'dracula' }

"
" Add maktaba and codefmt to the runtimepath.
" (The latter must be installed before it can be used.)
Plug 'google/vim-maktaba'
Plug 'google/vim-codefmt'
Plug 'google/vim-glaive'

" language server related
" Plug 'w0rp/ale'
Plug 'neoclide/coc.nvim', {'branch': 'release'}

if has('nvim')
  Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'}
  Plug 'nvim-lua/plenary.nvim'
  Plug 'nvim-telescope/telescope.nvim', { 'tag': '0.1.1' }
else
  Plug 'neovimhaskell/haskell-vim'
  Plug 'jelera/vim-javascript-syntax'
  Plug 'octol/vim-cpp-enhanced-highlight'
endif

call plug#end()

if has("win32")
  " enable ctrl+c/ctrl+v on windows
  source $VIMRUNTIME/mswin.vim
  " use ctrl+y as scroll down oneline
  unmap <C-Y>
  iunmap <C-Y>
endif

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" VIM General
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Sets how many lines of history VIM has to remember
set history=700

" Set to auto read when a file is changed from the outside
set autoread

" Always keep at least 7 lines to the cursor - when moving vertically using j/k
set scrolloff=7

" Turn on the Wild menu
set wildmenu
set wildignore=*.o,*~,*.pyc

"Always show current position
set ruler

" Give more space for displaying messages.
set cmdheight=2

" A buffer becomes hidden when it is abandoned
set hidden

" Configure backspace so it acts as it should act
set backspace=eol,start,indent
set whichwrap+=<,>,h,l

" Ignore case when searching
set ignorecase

" When searching try to be smart about cases
set smartcase

" Highlight search results
set hlsearch

" Makes search act like search in modern browsers
set incsearch

" Don't redraw while executing macros (good performance config)
set lazyredraw

" For regular expressions turn magic on
set magic

" Show matching brackets when text indicator is over them
set showmatch

" How many tenths of a second to blink when matching brackets
set mat=2

" Show line number
set number

" Set utf8 as standard encoding and en_US as the standard language
set encoding=utf8

" Use Unix as the standard file type
set ffs=unix,dos,mac

" No annoying sound on errors
set noerrorbells
set novisualbell
set t_vb=
set tm=500

" No autoformating when paste
set pastetoggle=<F2>

" Turn backup off, since most stuff is in SVN, git et.c anyway...
set nobackup
set nowritebackup
set noswapfile

" Be smart when using tabs ;)
set smarttab

" Linebreak on 500 characters
set lbr
set tw=500

" indent
set ai "Auto indent
set si "Smart indent
set wrap "Wrap lines

" Use spaces instead of tabs, 1 tab == 4 spaces
set expandtab
set tabstop=2
set shiftwidth=2
set softtabstop=2

" Enable syntax highlighting
syntax enable

" remap <leader> from \ to ,
let mapleader = ","
let g:mapleader = ","

" Only cursor the current window
"augroup BgHighlight
"  autocmd!
"  autocmd WinEnter * set cul
"  autocmd WinLeave * set nocul
"augroup END

" Delete trailing white space on save
func! DeleteTrailingWS()
  exe "normal mz"
  %s/\s\+$//ge
  exe "normal `z"
endfunc
autocmd BufWrite *.py :call DeleteTrailingWS()
autocmd BufWrite *.coffee :call DeleteTrailingWS()


" Search when matching a whole word
set cindent
au FileType c,cpp set iskeyword-=:
au FileType c,cpp set cinoptions+=t0,g0,=1s,(1s,N-s
au FileType py set iskeyword-=:
"au FileType python map <silent> <leader>b oimport pdb; pdb.set_trace()<esc>
"au FileType python map <silent> <leader>B Oimport pdb; pdb.set_trace()<esc>


" Return to last edit position when opening files
autocmd BufReadPost *
      \ if line("'\"") > 0 && line("'\"") <= line("$") |
      \   exe "normal! g`\"" |
      \ endif

" Remember info about open buffers on close
set viminfo^=%


"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Mappings
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Remove the Windows ^M - when the encodings gets messed up
noremap <Leader>m mmHmt:%s/<C-V><cr>//ge<cr>'tzt'm

" Format json
map <Leader>j !python -m json.tool<CR>

" Pressing ,ss will toggle and untoggle spell checking
map <leader>ss :setlocal spell!<cr>

" Reload vimrc
map <leader>xx :source ~/.vimrc<cr>

" Don't close window, when deleting a buffer
function! <SID>BufcloseCloseIt()
  let l:currentBufNum = bufnr("%")
  let l:alternateBufNum = bufnr("#")

  if buflisted(l:alternateBufNum)
    buffer #
  else
    bnext
  endif

  if bufnr("%") == l:currentBufNum
    new
  endif

  if buflisted(l:currentBufNum)
    execute("bdelete! ".l:currentBufNum)
  endif
endfunction

command! Bclose call <SID>BufcloseCloseIt()
" Close the current buffer
map <leader>bd :Bclose<cr>
" Close all the buffers
map <leader>ba :1,1000 bd!<cr>

" Tabs (deprecated), always prefer buffer than tab.
map <leader>tn :tabnew<cr>
map <leader>to :tabonly<cr>
map <leader>tc :tabclose<cr>
map <leader>tm :tabmove

" sudo in non-sudo mode
cmap w!! w !sudo tee % >/dev/null

" Treat long lines as break lines (useful when moving around in them)
map j gj
map k gk

" Smart way to move between windows
map <C-j> <C-W>j
map <C-k> <C-W>k
map <C-h> <C-W>h
map <C-l> <C-W>l

" Remap VIM 0 to first non-blank character
" map 0 ^


"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" GUI mode
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
if has("gui_running")
  " Don't show quick access bar
  set guioptions-=T

  " Don't show menu bar
  set guioptions-=m
  set guioptions+=e

  set t_Co=256
  set guitablabel=%M\ %t

  " Don't show right-hand scroll bar
  " set guioptions-=r

  " Don't show left-hand scroll bar
  set guioptions-=L

  " Set cursor line
  set cursorline
  highlight CursorLine guibg=Grey20

  " Set gui font
  if has("gui_gtk2")
    set guifont=Inconsolata\ 10
  elseif has("gui_macvim")
    set guifont=Menlo\ Regular:h14
  elseif has("gui_win32")
    set guifont=Consolas:h9:cANSI:qDRAFT
  endif

  " Set window position & size
  winpos 0 0
  set lines=60
  set columns=220
endif


"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Color scheme
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Enable 24bit color if supported
if exists('+termguicolors')
  let &t_8f="\<Esc>[38;2;%lu;%lu;%lum"
  let &t_8b="\<Esc>[48;2;%lu;%lu;%lum"
  set termguicolors
  " colorscheme dracula
endif

" Force monokai in diff mode
if &diff
  colorscheme monokai
endif


"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Plugin Configurations Begin
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

" Plugin 'majutsushi/tagbar'
map <leader>tb :TagbarToggle<cr>
let g:tagbar_compact=1
let g:tagbar_width=40
let g:tagbar_zoomwidth=0
let g:tagbar_left=0


" Plugin 'scrooloose/nerdtree'
" let g:NERDTreeWinPos="right"
let g:NERDTreeWinSize=45
" Fix OSX node delimiter encoding "^G" prefix
let g:NERDTreeNodeDelimiter = "\u00a0"
nmap <leader>nt :NERDTree<cr>
nmap <leader>nf :NERDTreeFind<cr>


" Plugin 'rking/ag.vim'
" g:ag_prg="ag --vimgrep --smart-case --path-to-ignore ~/.agignore"
" Dont jump to the first result automatically
ca Ag Ag!
cnoreabbrev Agc Ag! <cword>
let g:ag_highlight=1
let g:ag_format="%f:%l:%m"
" Note: <cword> reference the current word under cursor in command line mode.

" Plugin 'plasticboy/vim-markdown'
let g:vim_markdown_fenced_languages = ['csharp=cs']
let g:vim_markdown_conceal = 0
let g:vim_markdown_folding_disabled = 1
let g:vim_markdown_toc_autofit = 1

au FileType markdown setl sw=2 sts=2 et


"Plugin 'scrooloose/nerdcommenter'
let g:NERDSpaceDelims     = 0       " insert a space between leading char and 'comment' char
let g:NERDCompactSexyComs = 1
let g:NERDDefaultAlign    = 'left'


" Plugin 'godlygeek/tabular'
if exists(":Tabularize")
  nmap <Leader>t, :Tabularize /,/l0r1=<CR>
endif


" Plugin 'junegunn/fzf'
nnoremap <silent> <C-p> :FZF -m<cr>
" nnoremap <silent> <C-m> :Buffers<cr>
nmap ; :Buffers<cr>
nmap <Leader>r :Tags<CR>


" Plugin 'bling/vim-airline'
" Always show the status line
set laststatus=2
" airline and tagbar performance problem
let g:airline#extensions#tagbar#enabled = 0


" Plug 'google/vim-codefmt'
" codefmt recommanded settings
augroup autoformat_settings
  autocmd FileType bzl,bazel AutoFormatBuffer buildifier
  autocmd FileType c,cpp,proto,javascript AutoFormatBuffer clang-format
  autocmd FileType dart AutoFormatBuffer dartfmt
  autocmd FileType go AutoFormatBuffer gofmt
  autocmd FileType gn AutoFormatBuffer gn
  autocmd FileType html,css,sass,scss,less,json AutoFormatBuffer js-beautify
  autocmd FileType java AutoFormatBuffer google-java-format
  autocmd FileType python AutoFormatBuffer black
  " Alternative: autocmd FileType python AutoFormatBuffer autopep8
  autocmd FileType rust AutoFormatBuffer rustfmt
  autocmd FileType vue AutoFormatBuffer prettier
augroup END

"--------------------------------------------------------------
" Plugin 'w0rp/ale'

"" always use pylint
"let g:ale_python_pylint_executable = 'pylint3'
"" this options is moving into .pylintrc
"" let g:ale_python_pylint_options = ' --indent-string="    "'
"" let g:ale_python_pylint_options .= ' --ignore=C0330'

"let g:ale_maximum_file_size=204800 " 200 k

""let g:ale_use_ch_sendraw = 1
""let g:ale_lint_delay=50

"" https://www.vimfromscratch.com/articles/vim-and-language-server-protocol
"nmap gd :ALEGoToDefinition<CR>
"nmap gr :ALEFindReferences<CR>
"nmap gf :ALEInfoToFile<CR>
"nmap K :ALEHover<CR>
"let g:ale_completion_enabled=1


"--------------------------------------------------------------
" Plug 'neoclide/coc.nvim', {'branch': 'release'}
hi FgCocHintFloatBgCocFloating term=standout ctermfg=15 ctermbg=1 guifg=White guibg=Red

" Having longer updatetime (default is 4000 ms = 4 s) leads to noticeable
" delays and poor user experience.
set updatetime=300

" Don't pass messages to |ins-completion-menu|.
set shortmess+=c

" Always show the signcolumn, otherwise it would shift the text each time
" diagnostics appear/become resolved.
if has("nvim-0.5.0") || has("patch-8.1.1564")
  " Recently vim can merge signcolumn and number column into one
  set signcolumn=number
else
  set signcolumn=yes
endif

" Use tab for trigger completion with characters ahead and navigate.
" NOTE: Use command ':verbose imap <tab>' to make sure tab is not mapped by
" other plugin before putting this into your config.
inoremap <silent><expr> <TAB>
      \ coc#pum#visible() ? coc#pum#next(1):
      \ CheckBackspace() ? "\<Tab>" :
      \ coc#refresh()
inoremap <expr><S-TAB> coc#pum#visible() ? coc#pum#prev(1) : "\<C-h>"

function! s:check_back_space() abort
  let col = col('.') - 1
  return !col || getline('.')[col - 1]  =~# '\s'
endfunction

" Use <c-space> to trigger completion.
if has('nvim')
  inoremap <silent><expr> <c-space> coc#refresh()
else
  inoremap <silent><expr> <c-@> coc#refresh()
endif

" Make <CR> to accept selected completion item or notify coc.nvim to format
" <C-g>u breaks current undo, please make your own choice.
inoremap <silent><expr> <CR> coc#pum#visible() ? coc#pum#confirm()
                              \: "\<C-g>u\<CR>\<c-r>=coc#on_enter()\<CR>"

" Use `[g` and `]g` to navigate diagnostics
" Use `:CocDiagnostics` to get all diagnostics of current buffer in location list.
nmap <silent> [g <Plug>(coc-diagnostic-prev)
nmap <silent> ]g <Plug>(coc-diagnostic-next)

" GoTo code navigation.
nmap <silent> gd <Plug>(coc-definition)
nmap <silent> gy <Plug>(coc-type-definition)
nmap <silent> gi <Plug>(coc-implementation)
nmap <silent> gr <Plug>(coc-references)

" Use K to show documentation in preview window.
nnoremap <silent> K :call <SID>show_documentation()<CR>

function! s:show_documentation()
  if CocAction('hasProvider', 'hover')
    call CocActionAsync('doHover')
  else
    call feedkeys('K', 'in')
  endif
endfunction

" Highlight the symbol and its references when holding the cursor.
autocmd CursorHold * silent call CocActionAsync('highlight')

" Symbol renaming.
nmap <leader>rn <Plug>(coc-rename)

" Formatting selected code.
xmap <leader>f  <Plug>(coc-format-selected)
nmap <leader>f  <Plug>(coc-format-selected)

augroup mygroup
  autocmd!
  " Setup formatexpr specified filetype(s).
  autocmd FileType typescript,json setl formatexpr=CocAction('formatSelected')
  " Update signature help on jump placeholder.
  autocmd User CocJumpPlaceholder call CocActionAsync('showSignatureHelp')
augroup end

" Applying codeAction to the selected region.
" Example: `<leader>aap` for current paragraph
xmap <leader>a  <Plug>(coc-codeaction-selected)
nmap <leader>a  <Plug>(coc-codeaction-selected)

" Remap keys for applying codeAction to the current buffer.
nmap <leader>ac  <Plug>(coc-codeaction)
" Apply AutoFix to problem on the current line.
nmap <leader>qf  <Plug>(coc-fix-current)

" Run the Code Lens action on the current line.
nmap <leader>cl  <Plug>(coc-codelens-action)

" Map function and class text objects
" NOTE: Requires 'textDocument.documentSymbol' support from the language server.
xmap if <Plug>(coc-funcobj-i)
omap if <Plug>(coc-funcobj-i)
xmap af <Plug>(coc-funcobj-a)
omap af <Plug>(coc-funcobj-a)
xmap ic <Plug>(coc-classobj-i)
omap ic <Plug>(coc-classobj-i)
xmap ac <Plug>(coc-classobj-a)
omap ac <Plug>(coc-classobj-a)

" Remap <C-f> and <C-b> for scroll float windows/popups.
if has('nvim-0.4.0') || has('patch-8.2.0750')
  nnoremap <silent><nowait><expr> <C-f> coc#float#has_scroll() ? coc#float#scroll(1) : "\<C-f>"
  nnoremap <silent><nowait><expr> <C-b> coc#float#has_scroll() ? coc#float#scroll(0) : "\<C-b>"
  inoremap <silent><nowait><expr> <C-f> coc#float#has_scroll() ? "\<c-r>=coc#float#scroll(1)\<cr>" : "\<Right>"
  inoremap <silent><nowait><expr> <C-b> coc#float#has_scroll() ? "\<c-r>=coc#float#scroll(0)\<cr>" : "\<Left>"
  vnoremap <silent><nowait><expr> <C-f> coc#float#has_scroll() ? coc#float#scroll(1) : "\<C-f>"
  vnoremap <silent><nowait><expr> <C-b> coc#float#has_scroll() ? coc#float#scroll(0) : "\<C-b>"
endif

" Use CTRL-S for selections ranges.
" Requires 'textDocument/selectionRange' support of language server.
nmap <silent> <C-s> <Plug>(coc-range-select)
xmap <silent> <C-s> <Plug>(coc-range-select)

" Add `:Format` command to format current buffer.
command! -nargs=0 Format :call CocActionAsync('format')

" Add `:Fold` command to fold current buffer.
command! -nargs=? Fold :call     CocAction('fold', <f-args>)

" Add `:OR` command for organize imports of the current buffer.
command! -nargs=0 OR   :call     CocActionAsync('runCommand', 'editor.action.organizeImport')

" Add (Neo)Vim's native statusline support.
" NOTE: Please see `:h coc-status` for integrations with external plugins that
" provide custom statusline: lightline.vim, vim-airline.
set statusline^=%{coc#status()}%{get(b:,'coc_current_function','')}

" Mappings for CoCList
" Show all diagnostics.
nnoremap <silent><nowait> <space>a  :<C-u>CocList diagnostics<cr>
" Manage extensions.
nnoremap <silent><nowait> <space>e  :<C-u>CocList extensions<cr>
" Show commands.
nnoremap <silent><nowait> <space>c  :<C-u>CocList commands<cr>
" Find symbol of current document.
nnoremap <silent><nowait> <space>o  :<C-u>CocList outline<cr>
" Search workspace symbols.
nnoremap <silent><nowait> <space>s  :<C-u>CocList -I symbols<cr>
" Do default action for next item.
nnoremap <silent><nowait> <space>j  :<C-u>CocNext<CR>
" Do default action for previous item.
nnoremap <silent><nowait> <space>k  :<C-u>CocPrev<CR>
" Resume latest coc list.
nnoremap <silent><nowait> <space>p  :<C-u>CocListResume<CR>

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""'
" Telescope
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""'

if has('nvim')
  inoremap <silent><expr> <c-space> coc#refresh()
  " Find files using Telescope command-line sugar.
  nnoremap <leader>ff <cmd>Telescope find_files<cr>
  nnoremap <leader>fg <cmd>Telescope live_grep<cr>
  nnoremap <leader>fb <cmd>Telescope buffers<cr>
  nnoremap <leader>fh <cmd>Telescope help_tags<cr>
  nnoremap <silent><nowait> <space><space> <cmd>Telescope find_files<cr>
  nnoremap <silent><nowait> <space>g <cmd>Telescope live_grep<cr>
  nnoremap <silent><nowait> <space>b <cmd>Telescope buffers<cr>

  " Using Lua functions
  nnoremap <leader>ff <cmd>lua require('telescope.builtin').find_files()<cr>
  nnoremap <leader>fg <cmd>lua require('telescope.builtin').live_grep()<cr>
  nnoremap <leader>fb <cmd>lua require('telescope.builtin').buffers()<cr>
  nnoremap <leader>fh <cmd>lua require('telescope.builtin').help_tags()<cr>
endif

lua << EOF
require("telescope").setup({
  defaults = {
    mappings = {
      i = {
        ["<esc>"] = require("telescope.actions").close,
      },
    },
  },
})
EOF

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Plugin Configurations End
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

" fix ctrl left/right problem inside tmux
" https://superuser.com/questions/401926/how-to-get-shiftarrows-and-ctrlarrows-working-in-vim-in-tmux
if &term =~ '^screen'
  " tmux will send xterm-style keys when its xterm-keys option is on
  execute "set <xUp>=\e[1;*A"
  execute "set <xDown>=\e[1;*B"
  execute "set <xRight>=\e[1;*C"
  execute "set <xLeft>=\e[1;*D"
endif


" llvm tablegen produce .inc file.
augroup llvm_settings
  autocmd BufNewFile,BufRead *.inc set filetype=cpp
augroup END

" bazel hightlight
augroup bazel_settings
  autocmd BufNewFile,BufRead *.bazel set filetype=bzl
  autocmd BufNewFile,BufRead *.BUILD set filetype=bzl
  autocmd BufNewFile,BufRead BUILD set filetype=bzl
  autocmd BufNewFile,BufRead WORKSPACE set filetype=bzl
augroup END

" cpp settings.
augroup cpp_settings
  autocmd FileType cpp set matchpairs+=<:>
augroup END

" adjust popup window delay
set timeout
set ttimeout
set timeoutlen=2000
set ttimeoutlen=100

" include local configuration
if filereadable(glob("$HOME/.vimrc.local"))
  source $HOME/.vimrc.local
endif

" nvim-tree-sitter related.
if has('nvim')
lua <<EOF
  require'nvim-treesitter.configs'.setup {
    -- A list of parser names, or "all"
    ensure_installed = { "c", "cpp", "python", "rust" },

    -- Install parsers synchronously (only applied to `ensure_installed`)
    sync_install = false,

    -- List of parsers to ignore installing (for "all")
    -- ignore_install = { "javascript" },

    highlight = {
      -- `false` will disable the whole extension
      enable = true,

      -- NOTE: these are the names of the parsers and not the filetype. (for example if you want to
      -- disable highlighting for the `tex` filetype, you need to include `latex` in this list as this is
      -- the name of the parser)
      -- list of language that will be disabled
      -- disable = { "c", "rust" },

      -- Setting this to true will run `:h syntax` and tree-sitter at the same time.
      -- Set this to `true` if you depend on 'syntax' being enabled (like for indentation).
      -- Using this option may slow down your editor, and you may see some duplicate highlights.
      -- Instead of true it can also be a list of languages
      additional_vim_regex_highlighting = false,
    },
  }
EOF
endif

" Just for reference, linter will handle 80 lines.
" highlight ColorColumn ctermbg=246
" set colorcolumn=80
