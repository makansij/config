let s:save_cpo = &cpo
set cpo&vim

function! unite#sources#autocommands#define()
    return s:source
endfunction

let s:source = {
        \   'name': 'autocommands',
        \   'hooks': {},
        \   'action_table': {},
        \   'default_kind' : 'common',
        \}


let s:cached_result = []

function! s:source.gather_candidates(args, context) "{{{
    return s:cached_result
endfunction "}}}

function! s:source.hooks.on_init(args, context) "{{{
    " Get buffer number.
    let bufnr = get(a:args, 0, bufnr('%'))
    echomsg 'bufnr '.bufnr
    let oldnr = bufnr('%')
    echomsg 'oldnr '.oldnr
    if bufnr != bufnr('%')
        let oldnr = bufnr('%')
        execute 'buffer' bufnr
    endif

    " Get autocommand groups.
    redir => data
    silent! augroup
    redir END
    let groups = split(data, '  ')
    echomsg join(groups, ',')

    " Get autocommands for every group
    let groupData = {}
    for group in groups
        redir => data
        silent! exec "au ".group
        redir END
        let eventList = {} " events for group
        let commandList = []
        for line in split(data, '\n')
            let newName = 0
            if line =~ "--- Auto-Commands ---"
                continue
            endif
            if line !~ "^ "
                if exists("eventName")
                    let eventList[eventName] = commandList
                endif
                let eventName = substitute(line, group.'. ', '', '')
                let newName = 1
                let commandList = get(eventList, eventName, [])
            else
                call add(commandList, line)
            endif
        endfor
        let groupData[group] = eventList
    endfor
    echomsg string(groupData)


    "TODO why?
    if oldnr != bufnr('%')
        execute 'buffer' oldnr
    endif

    let s:cached_result = []

    let au_nodes = {}
    "for line in au_lines
        "if line !~ '^ '

        "endif
    "endfor

    "let mapping_lines = filter(copy(mapping_lines),
            "\ "v:val =~ '\\s\\+\\*\\?@'")
            "\ + filter(copy(mapping_lines),
            "\ "v:val !~ '\\s\\+\\*\\?@'")

    "for line in map(mapping_lines,
            "\ "substitute(v:val, '<NL>', '<C-J>', 'g')")
        "let map = matchstr(line, '^\a*\s*\zs\S\+')
        "if map =~ '^<SNR>' || map =~ '^<Plug>'
        "continue
        "endif
        "let map = substitute(map, '<NL>', '<C-j>', 'g')
        "let map = substitute(map, '\(<.*>\)', '\\\1', 'g')

        "call add(s:cached_result, {
            "\ 'word' : line
            "\ })
    "endfor

endfun "}}}

function! s:source.gather_candidates(args, context) "{{{
  return s:cached_result
endfunction"}}}









let &cpo = s:save_cpo
unlet s:save_cpo
