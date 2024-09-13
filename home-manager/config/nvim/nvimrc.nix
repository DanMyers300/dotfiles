{
  inputs,
  lib,
  config,
  pkgs,
  ...
} : {
programs.neovim.extraConfig = ''



    """""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
    "
    "               ██╗   ██╗██╗███╗   ███╗██████╗  ██████╗
    "               ██║   ██║██║████╗ ████║██╔══██╗██╔════╝
    "               ██║   ██║██║██╔████╔██║██████╔╝██║
    "               ╚██╗ ██╔╝██║██║╚██╔╝██║██╔══██╗██║
    "                ╚████╔╝ ██║██║ ╚═╝ ██║██║  ██║╚██████╗
    "                 ╚═══╝  ╚═╝╚═╝     ╚═╝╚═╝  ╚═╝ ╚═════╝
    "
    """""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""


        set nocompatible

        set visualbell

    " Disable auto commenting in a new line
        autocmd Filetype * setlocal formatoptions-=c formatoptions-=r  formatoptions-=o

        set encoding=UTF-8

        filetype on

        set nospell

        set smarttab

        set path+=**

        filetype plugin on

        filetype indent on

        syntax on

        set number relativenumber

        set mouse=a

        "set cursorline

        "set cursorcolumn

        set shiftwidth=4 expandtab
        set tabstop=4 expandtab

        autocmd Filetype html setlocal tabstop=2 shiftwidth=2 expandtab

        set list lcs=trail:·,tab:»·,lead:·,leadmultispace:·

        set nobackup

        set nowrap 

    " While searching though a file incrementally highlight matching characters as you type.
        set incsearch
        set hlsearch
        set ignorecase
        set showmatch

    " Show partial command you type in the last line of the screen.
        set showcmd

    " Show the mode you are on the last line.
        set showmode

    " Set the commands to save in history default number is 20.
        set history=1000

    " Setting the split window to open as i like (like in a WM - qtile)
        set splitbelow splitright

    " Enable auto completion menu after pressing TAB.
        set wildmenu

    " There are certain files that we would never want to edit with Vim.
    " Wild menu will ignore files with these extensions.
        set wildignore=*.docx,*.jpg,*.png,*.gif,*.pdf,*.pyc,*.exe,*.flv,*.img,*.xlsx

    " If Vim version is equal to or greater than 7.3 enable undo file.
    " This allows you to undo changes to a file even after saving it.
        if version >= 703
            set undodir=~/.vim/backup
            set undofile
            set undoreload=10000
        endif

    " File Browsing settings
        let g:netrw_banner=0
        let g:netrw_liststyle=3
        let g:netrw_showhide=1
        let g:netrw_winsize=20

    " Auto Completion - Enable Omni complete features
        set omnifunc=syntaxcomplete#Complete

        " Enable Spelling Suggestions for Auto-Completion:
        set complete+=k
        set completeopt=menu,menuone,noinsert

        inoremap <expr> <Tab> TabComplete()
        fun! TabComplete()
            if getline('.')[col('.') - 2] =~ '\K' || pumvisible()
                return "\<C-N>"
            else
                return "\<Tab>"
            endif
        endfun

        inoremap <expr> <CR> pumvisible() ? "\<C-Y>" : "\<CR>"
        autocmd InsertCharPre * call AutoComplete()
        fun! AutoComplete()
            if v:char =~ '\K'
                \ && getline('.')[col('.') - 4] !~ '\K'
                \ && getline('.')[col('.') - 3] =~ '\K'
                \ && getline('.')[col('.') - 2] =~ '\K'
                \ && getline('.')[col('.') - 1] !~ '\K'
                call feedkeys("\<C-N>", 'n')
            end
        endfun

    " Closing compaction in insert mode
        inoremap [ []<left>
        inoremap ( ()<left>
        inoremap { {}<left>
        inoremap /* /**/<left><left>

    "------------------STATUS_LINE------------------


    " Status line
        set laststatus=2
        set statusline=
        set statusline+=%2*
        set statusline+=%{StatuslineMode()}
        set statusline+=\ 
        set statusline+=%{SpellCheckStatus()}
        set statusline+=%1*
        set statusline+=\ 
        set statusline+=%3*
        set statusline+=<
        set statusline+=-
        set statusline+=\ 
        set statusline+=%f
        set statusline+=\ 
        set statusline+=-
        set statusline+=>
        set statusline+=\ 
        set statusline+=%4*
        set statusline+=%m
        set statusline+=%=
        set statusline+=%h
        set statusline+=%r
        set statusline+=%4*
        set statusline+=%c
        set statusline+=/
        set statusline+=%l
        set statusline+=/
        set statusline+=%L
        set statusline+=\ 
        set statusline+=%1*
        set statusline+=|
        set statusline+=%y
        set statusline+=\ 
        set statusline+=%4*
        set statusline+=%P
        set statusline+=\ 
        set statusline+=%3*
        set statusline+=t:
        set statusline+=%n
        set statusline+=\ 

    " Mode
        function! StatuslineMode()
          let l:mode=mode()
          if l:mode==#"n"
            return "NORMAL"
          elseif l:mode==#"V"
            return "VISUAL LINE"
          elseif l:mode==?"v"
            return "VISUAL"
          elseif l:mode==#"i"
            return "INSERT"
          elseif l:mode ==# "\<C-V>"
            return "V-BLOCK"
          elseif l:mode==#"R"
            return "REPLACE"
          elseif l:mode==?"s"
            return "SELECT"
          elseif l:mode==#"t"
            return "TERMINAL"
          elseif l:mode==#"c"
            return "COMMAND"
          elseif l:mode==#"!"
            return "SHELL"
          else
              return "VIM"
          endif
        endfunction

    " Spell Check Status
        function! SpellCheckStatus()
            if &spell 
                return " [SPELL]"
            else
                return ""
            endif   
        endfunction


    "------------------KEY_BINDINGS------------------


    " Spell-check on\off
        map <C-z> :setlocal spell! spelllang=en_us<CR>

    " Type jj to exit insert mode quickly.
        inoremap jj <Esc>

    " Format a paragraph into lines
        map Q gq<CR>

    " Set the space  as the leader key.
        let mapleader = " "

    " Select all the text
        nnoremap <leader>a ggVG

    " Opening a file explorer
        map <leader>e :Lex<CR>

    " Opening a file from explorer
        map <leader>o :Explore<CR>

    " Split the window. y - y axis | x - x axis 
        map <leader>y :split<space>
        map <leader>x :vsplit<space>

    " Navigate the split view easier by pressing CTRL+j, CTRL+k, CTRL+h, or CTRL+l.
        nnoremap <c-j> <c-w>j
        nnoremap <c-k> <c-w>k
        nnoremap <c-h> <c-w>h
        nnoremap <c-l> <c-w>l

    " Resize split windows using arrow keys by pressing:
    " CTRL+UP, CTRL+DOWN, CTRL+LEFT, or CTRL+RIGHT.
        noremap <a-up> <c-w>+
        noremap <a-down> <c-w>-
        noremap <a-left> <c-w>>
        noremap <a-right> <c-w><

    " Moving between tabs
        map <leader>t gt

    " Opening\Creating a file in a new tab - write the tab to open
        noremap <leader>c :tabedit<space>

    " Saving a file using CTRL+S
        map <C-S> :w<CR>

    " Quitting and saving a file using CTRL+q
        map <C-q> :wq<CR>

    " Surround word with a wanted character
        nnoremap <leader>sw <cmd>echo "Press a character: " \| let c = nr2char(getchar()) \| exec "normal viwo\ei" . c . "\eea" . c . "\e" \| redraw<CR>

    " Replace all occurrences of a word
        nnoremap <leader>rw :%s/\<<c-r><c-w>\>//g<left><left>

    " Map V-Block to not confuse with paste
        noremap <leader>v <C-v>

    " For copy and paste
        map <C-V> "+P
        vnoremap <C-C> "*y :let @+=@*<CR>

    " Display the registers
        nnoremap <leader>r <cmd>registers<CR>

    " Clear search results
        map <leader>h <cmd>noh<CR>

    " Output the current syntax group
        nnoremap <f10> :echo "hi<" . synIDattr(synID(line("."),col("."),1),"name") . '> trans<'
        \ . synIDattr(synID(line("."),col("."),0),"name") . "> lo<"
        \ . synIDattr(synIDtrans(synID(line("."),col("."),1)),"name") . ">"<cr>


'';
}
