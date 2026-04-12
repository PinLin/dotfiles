syntax on
set autochdir
set backspace=2
set encoding=utf-8
set fileencodings=utf-8,utf-16,big5,gb2312,gbk,gb18030,euc-jp,euc-kr,latin1
set nocompatible
set t_Co=256
set laststatus=2

filetype plugin indent on
set autoindent
set expandtab
set softtabstop=4
set shiftwidth=4
set tabstop=4

" Search
set incsearch
set hlsearch
set ignorecase
set smartcase

nnoremap <F2> :<C-U>setlocal lcs=tab:>-,trail:-,eol:$ list! list? <CR>
nnoremap <Esc><Esc> :nohlsearch<CR>

set number
set mouse=a
set hidden
set cursorline
set ruler
set showcmd
set showmode
set wildmenu
set wildmode=longest:full,full
set statusline=[%{expand('%:p')}]%m[%{strlen(&fenc)?&fenc:&enc},\ %{&ff},\ %{strlen(&filetype)?&filetype:'plain'}]%{FileSize()}%{IsBinary()}%=%c,%l/%L\ [%3p%%]

autocmd FileType make setlocal noexpandtab

function IsBinary()
    if (&binary == 0)
        return ""
    else
        return "[Binary]"
    endif
    endfunction

    function FileSize()
    let bytes = getfsize(expand("%:p"))
    if bytes <= 0
        return "[Empty]"
    endif
    if bytes < 1024
        return "[" . bytes . "B]"
    elseif bytes < 1048576
        return "[" . (bytes / 1024) . "KB]"
    else
        return "[" . (bytes / 1048576) . "MB]"
    endif
endfunction

" vim-oscyank: yank → OSC 52 → 系統剪貼簿
if exists('##TextYankPost')
    augroup VimOSCYankPost
        autocmd!
        autocmd TextYankPost *
            \ if v:event.operator is 'y' && v:event.regname is '' |
            \   call OSCYankRegister('"') |
            \ endif
    augroup END
endif

command W w !sudo tee %
