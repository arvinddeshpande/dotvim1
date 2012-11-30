""Steve's vimrc (Modified from the original Mandrake vimrc)
"Steve <lonetwin@yahoo.com>

"Turn syntax hilighting on.
syntax on

set title

"Makes syntax highlighing lighter.
set background=dark

"Show the position of the cursor.
set ruler
set rulerformat=%50(%-30(%f%)\ %l,%c%V\ %p%%%)

"Set a statusbar.
set statusline=%<%f%=\ [%1*%M%*%n%R%H]\ %-19(%3l,%02c%03V%)%O'%02b'
"Always show the status line even when single file's open
set laststatus=2

"Show (partial) command in status line.
set showcmd
"set showtabline=2

"Some macros to manage the buffer of vim.
:map <F2> :vertical wincmd f<CR>

map <F5> :bp<C-M>
map <F6> :bn<C-M>
map <F7> :bd<C-M>

"Helpers for the tagbar plugin
nmap <F12> :TagbarToggle<CR>

" Following two lines are for the tagbar plugin
let g:tagbar_ctags_bin = '/mesa/devtrees/adeshp01/tools/bin/ctags'
let g:tagbar_left = 1

" Let's try something for the sqlplus plugin
" Somehow I am confident that I will be able to make it work than the emacs
" one.
let g:sqlplus_userid = ''
let g:sqlplus_password = ''
let g:sqlplus_db = "/@homer"
let g:sqlplus_path = "/mesa/oracle/current/bin/sqlplus "

"Terminal for 80 char ? so vim can play till 79 char.
set textwidth=79
"set wrap

" This is mouse enable stuff mouse support for console.
" And this works on Solaris too when Terminal used is DTTERM and not Xterm
"if has("mouse")
"  set mouse=a
"  set ttymouse=xterm
"endif

set autoindent
set smartindent
set tabstop=2                   " Tabs (ASCII 0x09) are always 8 characters!!!
set softtabstop=2 shiftwidth=2  " default indentation level
set expandtab                   " use spaces instead of tabs for indentation
set smarttab                    " ...but do it smartly  
set incsearch                   " Show the matches as we type
set hlsearch                    " Highlight all matches of the last search pattern
set ignorecase                  " Ignore case in search pattern 
set showmatch                   " show matching parens/brackets
set joinspaces                  " insert 2 spaces after a period when joining lines
set history=50                  " Keep command history
set backup                      " Keep backup of files
set backupdir=~/tmp/            " where to keep 'em
set dictionary=/usr/share/dict/words " For completion
set noinfercase                 " Don't infer case from the pattern being
                                " typed while searching.  
set showmode                    " Show the mode we are in
set warn                        " Give a warning message when a shell command
                                " is used while the buffer has been changed.
set modeline                    " Set the 'modeline' options if they are defined
set pastetoggle=<F2>            " Mapping to take care of unsetting ai and
                                " smartindent when pasting text.


" Make the up and down movements move by "display" lines:
map j      gj
map k      gk
map <Down> gj
map <Up>   gk

" Cycle between windows and make active window full size
map <C-N> <C-W>w<C-W>_

" Source man plugin
runtime! ftplugin/man.vim

let python_highlight_all = 1    " Read the vim syntax file for python to know
                                " what this does.

" Function to use the 'intelligent' tab completion defined below.
" Try it in python code !!!
function! <SID>InsertTabWrapper(direction)
    let idx = col('.') - 1
    let str = getline('.')

    if a:direction > 0 && idx >= 2 && str[idx - 1] == ' '
  \&& str[idx - 2] =~? '[a-z]'
if &softtabstop && idx % &softtabstop == 0
    return "\<BS>\<Tab>\<Tab>"
else
    return "\<BS>\<Tab>"
endif
    elseif idx == 0 || str[idx - 1] !~? '[a-z]'
        return "\<Tab>"
    elseif a:direction > 0
        return "\<C-p>"
    else
        return "\<C-n>"
    endif
endfunction

" Intelligent tab completion
inoremap <silent> <Tab> <C-r>=<SID>InsertTabWrapper(1)<CR>
inoremap <silent> <S-Tab> <C-r>=<SID>InsertTabWrapper(-1)<CR>

" Vimspell defaults
" let spell_executable = "aspell"
let spell_insert_mode = 1

" CVS plugin defaults
augroup CVSCommand
    au CVSCommand User CVSBufferCreated silent! nmap <unique> <buffer> q:bwipeout<cr>
    let CVSCommandEdit = 'split'        " Split the buffer instead of replacing it
    let CVSCommandDiffSplit = 'edit'    " ...but don't do it for diff's
augroup END

command -nargs=+ SReplace call StepReplace(<f-args>)
"makes use of register y
function StepReplace(...)
  if a:0 == 1
    let @y = input("Replace with: ", @y)
    let y = @y
    if @y =~ "\\d\\+$"
      let n = substitute(@y, ".\\{-}\\(\\d\\+\\)$", "\\1", "") + a:1
      let @y = substitute(@y, "\\(.\\{-}\\)\\d\\+$", "\\1".n, "")
    endif
    return y
  elseif a:0 == 3
    let @y = a:2
    execute "%s/".a:1."/\\=StepReplace(".a:3.")/".(&gdefault ? "" : "g")."c"
  else
    echo "Usage: SReplace <search> <substitute> <increment>"
  endif
endfunction

autocmd BufNewFile,BufRead *.inc  set filetype=perl
autocmd BufNewFile,BufRead *.html set filetype=perl
