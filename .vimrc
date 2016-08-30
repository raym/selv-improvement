set nocompatible              " be iMproved, required
filetype off                  " required

" set the runtime path to include Vundle and initialize
set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()
" alternatively, pass a path where Vundle should install plugins
"call vundle#begin('~/some/path/here')

" let Vundle manage Vundle, required
Plugin 'gmarik/Vundle.vim'

" The following are examples of different formats supported.
" Keep Plugin commands between vundle#begin/end.
" plugin on GitHub repo
Plugin 'tpope/vim-fugitive'
Plugin 'godlygeek/tabular'
" plugin from http://vim-scripts.org/vim/scripts.html
"Plugin 'L9'
" Git plugin not hosted on GitHub
"Plugin 'git://git.wincent.com/command-t.git'
" git repos on your local machine (i.e. when working on your own plugin)
"Plugin 'file:///home/gmarik/path/to/plugin'
" The sparkup vim script is in a subdirectory of this repo called vim.
" Pass the path to set the runtimepath properly.
"Plugin 'rstacruz/sparkup', {'rtp': 'vim/'}
" Avoid a name conflict with L9
"Plugin 'user/L9', {'name': 'newL9'}

" All of your Plugins must be added before the following line
call vundle#end()            " required
filetype plugin indent on    " required
" To ignore plugin indent changes, instead use:
"filetype plugin on
"
" Brief help
" :PluginList       - lists configured plugins
" :PluginInstall    - installs plugins; append `!` to update or just :PluginUpdate
" :PluginSearch foo - searches for foo; append `!` to refresh local cache
" :PluginClean      - confirms removal of unused plugins; append `!` to auto-approve removal
"
" see :h vundle for more details or wiki for FAQ
" Put your non-Plugin stuff after this line

set number
set autoindent
set nocompatible
" tabstop, softtabstop, shiftwidth set farther down in the file
set ruler
set nohls
set ignorecase
set noshowmatch
set scrolljump=5
set scrolloff=3
let loaded_matchparen = 1
syntax on
color blackboard " http://www.vim.org/scripts/script.php?script_id=2280

" \p to toggle paste mode and autoindent mode
nmap <leader>p :set autoindent!<CR>

""""""""""""""""""
""""" vimcasts.org
""""""""""""""""""

"""""""""""""
""" episode 1 show invisibles
"""""""""""""
set list
" Shortcut to rapidly toggle `set list`
nmap <leader>l :set list!<CR>
" set symbols for hidden chars, e.g. trailing whitespace, tabstops and EOLs
set listchars=trail:☠,tab:^I,eol:$

"Invisible character colors (not working yet... osx?)
highlight NonText guifg=#ffffff
highlight SpecialKey guifg=#ffffff

"""""""""""""
""" episode 2 tabs and spaces
"""""""""""""
set ts=2 sts=2 sw=2 expandtab
" function for settin tabstop, softtabstop and shiftwidth to the same value
" creates command :Stab
command! -nargs=* Stab call Stab()
function! Stab()
  let l:tabstop = 1 * input('set tabstop = softtabstop = shiftwidth = ')
  if l:tabstop > 0
    let &l:sts = l:tabstop
    let &l:ts = l:tabstop
    let &l:sw = l:tabstop
  endif
  call SummarizeTabs()
endfunction

function! SummarizeTabs()
  try
    echohl ModeMsg
    echon 'tabstop='.&l:ts
    echon ' shiftwidth='.&l:sw
    echon ' softtabstop='.&l:sts
    if &l:et
      echon ' expandtab'
    else
      echon ' noexpandtab'
    endif
  finally
    echohl None
  endtry
endfunction

"""""""""""""
""" episode 3 whitespace preferences and filetypes
"""""""""""""
" Only do this part when compiled with support for autocommands
if has("autocmd")
  " Enable file type detection
  filetype on

  " Syntax of these languages is fussy over tabs Vs spaces
  autocmd FileType make setlocal ts=8 sts=8 sw=8 noexpandtab
  "autocmd FileType yaml setlocal ts=2 sts=2 sw=2 expandtab

  " Customisations based on house-style (arbitrary)
  "autocmd FileType html setlocal ts=2 sts=2 sw=2 expandtab
  "autocmd FileType css setlocal ts=2 sts=2 sw=2 expandtab
  "autocmd FileType javascript setlocal ts=4 sts=4 sw=4 noexpandtab

  " Treat .rss files as XML
  "autocmd BufNewFile,BufRead *.rss setfiletype xml
endif

"""""""""""""
""" episode 4 tidying whitespace
"""""""""""""
command! -nargs=* Trim call <SID>StripTrailingWhitespaces()
function! <SID>StripTrailingWhitespaces()
    " Preparation: save last search, and cursor position.
    let _s=@/
    let l = line(".")
    let c = col(".")
    " Do the business:
    %s/\s\+$//e
    " Clean up: restore previous search history, and cursor position
    let @/=_s
    call cursor(l, c)
endfunction
" for the autocmd below, you can replace '*' with e.g. '*.html,*.css,*.js,*.etc' -- one way to limit when this runs
autocmd BufWritePre * :call <SID>StripTrailingWhitespaces()


"""""""""""""
" episode 24
"""""""""""""
" Source the vimrc file after saving it
if has("autocmd")
  autocmd bufwritepost .vimrc source $MYVIMRC
endif
" makes ,v shortcut to editing vimrc
let mapleader = ","
nmap <leader>v :tabedit $MYVIMRC<CR>

