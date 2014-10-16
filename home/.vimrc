" vim: set sw=4 ts=4 sts=4 et tw=78 foldmarker={{{,}}} foldmethod=marker:
"~/.vimrc.plugins
"~/.vimrc.mappings
"~/.vimrc.options
"~/.vimrc.functions

" set mapleader here so one can define leader mappings in .vimrc.plugins
let mapleader = ","
let maplocalleader = "\\"

" detect EnvironMent {{{
    let s:is_windows = has('win32') || has('win64')
    let s:is_cygwin = has('win32unix')
    let s:is_macvim = has('gui_macvim')
    if !executable('git')
        let msg = ['git not found, no plugins will be updated']
        echohl WarningMsg | echomsg join(msg, "\n") | echohl None
        "throw msg
    endif


"}}}
" setup & neobundle {{{
    if has('vim_starting')
        set nocompatible
        set runtimepath+=~/.vim/bundle/neobundle.vim/
    endif
    call neobundle#begin(expand('~/.vim/bundle/'))
    " Let NeoBundle manage NeoBundle
    NeoBundleFetch 'Shougo/neobundle.vim'
    NeoBundle 'Shougo/vimproc', {
        \ 'build' : {
        \     'windows' : 'make -f make_mingw32.mak',
        \     'cygwin' : 'make -f make_cygwin.mak',
        \     'mac' : 'make -f make_mac.mak',
        \     'unix' : 'make -f make_unix.mak',
        \    },
        \ }
    if filereadable(expand('~/.vimrc.plugins'))
        source ~/.vimrc.plugins
    endif
    call neobundle#end()
    filetype plugin indent on     " Required!
    " TODO move to .vimrc.plugins if bug is fixed
    syntax enable
    colorscheme hybrid
    NeoBundleCheck
	if !has('vim_starting')
	  " Call on_source hook when reloading .vimrc.
	  call neobundle#call_hook('on_source')
	endif

"}}}
" include other vimrcs {{{
if filereadable(expand("~/.vimrc.functions"))
    source ~/.vimrc.functions
endif
if filereadable(expand("~/.vimrc.options"))
    source ~/.vimrc.options
endif
if filereadable(expand("~/.vimrc.mappings"))
    source ~/.vimrc.mappings
endif
"}}}
" Autocommands {{{
augroup customFileTypes
    autocmd!
    au BufNewFile,BufRead *.launch,*.rss setfiletype xml
    "tpl already defined 'setfiletype' wont override so we need to use 'set ft='
    au BufNewFile,BufRead *.tpl set filetype=html
    au BufNewFile,BufRead *.jade set filetype=jade
augroup END
augroup filetype_foldings
    autocmd!
    "au FileType c,h,cpp setlocal foldmethod=marker foldmarker=region,noregion
    au FileType c,h,cpp setlocal foldmethod=syntax sw=2 ts=2 sts=2 et tw=79
    au FileType python setlocal foldmethod=indent ts=4 sw=4
    au FileType jade setlocal foldmethod=indent sw=2 sw=2 sts=2 et
    au FileType javascript,coffee setlocal foldmethod=indent sw=2 sw=2 sts=2 et
    au FileType html setlocal sw=2 sw=2 sts=2 et
    au FileType make setlocal ts=8 sts=8 sw=8 noet " But TABs are needed in Makefiles
    au FileType tex setlocal ts=4 sts=4 sw=4 noet
    au FileType tsv setlocal ts=4 sts=4 sw=4 noet
    " done by latexBox
    let g:LatexBox_Folding=1
    "au FileType tex setlocal foldmethod=marker
    au FileType vim setlocal fdm=marker foldlevel=0 foldlevelstart=0
augroup end
augroup general_options
    autocmd!
    " automatically delete trailing whitespaces on buffer write
    autocmd BufWritePre * :call StripTrailingWhitespaces()
    " auto trim empty lines on end of file
    autocmd BufWritePre * :call TrimEndLines()
    "au FocusLost * :silent! wall                 " Save on FocusLost
    au FocusLost * call feedkeys("\<C-\>\<C-n>") " Return to normal mode on FocustLost
augroup end
augroup plugin_options
    autocmd!
    autocmd FileType css setlocal omnifunc=csscomplete#CompleteCSS
    autocmd FileType html,markdown setlocal omnifunc=htmlcomplete#CompleteTags
    autocmd FileType javascript setlocal omnifunc=javascriptcomplete#CompleteJS
    autocmd FileType xml setlocal omnifunc=xmlcomplete#CompleteTags
    autocmd FileType java setlocal omnifunc=javacomplete#Complete
    autocmd!
    "TODO not working at the moment
    autocmd FileType python nnoremap <silent> <buffer> <leader>re :call jedi#rename()<cr>
    autocmd FileType python nnoremap <silent> <buffer> <leader>d :call jedi#goto_definitions()<cr>
    autocmd FileType python nnoremap <silent> <buffer> <leader>g :call jedi#goto_assignments()<cr>
    autocmd FileType python nnoremap <silent> <buffer> <leader>n :call jedi#usages()<cr>
    "autocmd FileType let g:jedi#force_py_version = 3
augroup end

"}}} Options
" useful commands {{{
"" :retab! -
"" function! <SID>namebla - <SID> is being replaced by unique scrip identifier
"" gv - repeat last visual selection
"" g; - go in changelist backwards
"" g, - go in changelist forward
"" :changes - view changelist
"" <c-o> - jumplist backwards
"" <c-i> - jumplist forwards
"" <c-o> - (in insert mode) next command as normal, useful for mappings
"" :jumps - view jumplist
"" <c-]> - follow link (in vim help)
"" <c-b> - pagedown (back)
"" <c-f> - pageup (forward)
"" :options - show all 'set' options with explanation
"}}}
" profiling {{{
"" as mentioned on http://stackoverflow.com/questions/12213597/how-to-see-which-plugins-are-making-vim-slow
":profile start profile.log
":profile func *
":profile file *
"" At this point do slow actions
":profile pause
":noautocmd qall!
"}}}
"python << EOF
"import vim
"    from vim_debug.commands import debugger_cmd
"    vim.command('let has_debug = 1')
"except ImportError, e:
"    vim.command('let has_debug = 0')
"    print 'python module vim_debug not found...'
"EOF
