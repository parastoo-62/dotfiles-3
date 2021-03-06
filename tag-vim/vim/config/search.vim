set gdefault                      " default to global substitutions on lines
set ignorecase                    " Case-insensitive searching.
set smartcase                     " But case-sensitive if expression contains a capital letter.
set hlsearch                      " Highlight matches.
set showmatch                     " Show all matches
autocmd BufReadCmd set nohlsearch " on opening the file, clear search-highlighting

" Use The Silver Searcher https://github.com/ggreer/the_silver_searcher
if executable('ag')
  " Use Ag over Grep
  set grepprg=ag\ --nogroup\ --nocolor

  " Use ag in CtrlP for listing files. Lightning fast and respects .gitignore
  let g:ctrlp_user_command = 'ag -Q --files-with-matches --hidden --nocolor -g "" %s'

  " ag is fast enough that CtrlP doesn't need to cache
  let g:ctrlp_use_caching = 0
endif

augroup search
  autocmd!

  " Open the quickfix window with all grep commands
  autocmd QuickFixCmdPost *grep* cwindow
augroup END

" Search silently
command! -nargs=+ -complete=file -bar Gr silent! grep! <args> | redraw!

" Map Gr directly to \ for speeeed
nnoremap \ :Gr<SPACE>

" bind K to grep word under cursor
nnoremap K :Gr <C-R><C-W><CR>

" Move the search term to the middle of the screen if the screen has changed
" position.
" Stolen from @keith:
" https://github.com/keith/dotfiles/commit/20f98a645dd9ebcd24fa96d3aac0e9fe34a21a6a
function! s:NextAndCenter(cmd)
  let view = winsaveview()
  execute "normal! " . a:cmd

  if view.topline != winsaveview().topline
    normal! zzzv
  endif
endfunction

nnoremap <silent> n :call <SID>NextAndCenter('n')<CR>
nnoremap <silent> N :call <SID>NextAndCenter('N')<CR>
