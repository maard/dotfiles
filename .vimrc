set nocompatible
set autoindent
set backspace=indent,eol,start
set history=50
set incsearch
set nobackup
set ruler
set showcmd
set term=xterm

syntax on
set hls

if has("autocmd")
  filetype plugin indent on

  augroup vimrcEx
  au!

  autocmd BufReadPost *
    \ if line("'\'") > 0 && line("'\'") <= line("$") |
    \   exe "normal g`\"" |
    \ endif
  autocmd END
else
  set autoindent
endif

" get it from https://github.com/ctrlpvim/ctrlp.vim
set runtimepath^=~/.vim/bundle/ctrlp.vim

let g:ctrlp_prompt_mappings = {
 \ 'AcceptSelection("e")': ['<c-t>', '<2-LeftMouse>'],
 \ 'AcceptSelection("t")': ['<cr>'] }

set et
set ts=2
set sw=2
set nu
set laststatus=2
set statusline=[%c\ %l/%L\ %p%%]\ %r%m%f%=%b\ 0x%B

if &diff
  colorscheme darkblue
endif

noremap n nzz
noremap N Nzz

