# Clipboard over OSC 52 (tmux + vim)

How yanking in vim ends up in the clipboard on my physical machine, even
when vim runs on a remote host through ssh and tmux.

## What OSC 52 is

OSC 52 is a terminal escape sequence (`ESC ] 52 ; c ; <base64> ESC \`) that
lets a program inside the terminal talk to the system clipboard of the
machine the terminal runs on. It has two halves with very different
reliability:

- **Copy (write)** -- the program base64-encodes text and emits the escape;
  the terminal stores it in the clipboard. Widely supported and reliable.
- **Paste (read)** -- the program emits `ESC ] 52 ; c ; ? ESC \` and the
  terminal answers with the clipboard contents. Most terminals **block**
  this or gate it behind a permission prompt for security, and it does not
  survive tmux/ssh cleanly. We do not rely on it.

So this setup uses OSC 52 for **copy only**. Paste is handled differently
(see the behavior table).

## The path a yank travels

```
remote host                          physical machine
+-----------------------+            +----------------------+
| vim                   |            | kitty (terminal)     |
|   TextYankPost        |            |                      |
|   -> echoraw OSC 52 --+--ssh-->----+--> tmux --> kitty --> system clipboard
+-----------------------+            +----------------------+
```

Each layer just has to forward the escape sequence outward. The clipboard
that ends up holding the text is the one on the physical machine, which is
exactly what you want when copying out of a remote editor.

## tmux: forwarding the escape

tmux sits between vim and the outer terminal, so it must pass OSC 52
through. Relevant settings in `dot_tmux.conf.tmpl`:

```tmux
set -g allow-passthrough all
set -s set-clipboard external
set -as terminal-features ',xterm-kitty:clipboard,tmux-256color:clipboard,screen-256color:clipboard'
```

- `set-clipboard external` -- tmux accepts OSC 52 set requests from programs
  inside it and forwards them to the outer terminal (instead of only storing
  them in a tmux buffer).
- `terminal-features ...:clipboard` -- tells tmux the outer terminal can
  handle clipboard escapes, so it is willing to forward them.
- `allow-passthrough all` -- lets raw escape sequences pass through.

Without `set-clipboard external`, a yank would only land in a tmux paste
buffer and never reach the real clipboard.

## vim: emitting the escape

Config lives in `dot_vim/settings/general.vim`. Requires a vim with the
`+clipboard` feature (and the `base64_encode`, `str2blob`, `echoraw`
builtins, present in recent 9.1).

```vim
" p pastes from vim's own register instantly, never reads the clipboard
set clipboard=

function! s:Osc52Yank() abort
  if v:event.operator !=# 'y'        " only real yanks, not delete/change
    return
  endif
  let l:reg = v:event.regname
  if l:reg !=# '' && l:reg !=# '+' && l:reg !=# '*'
    return                           " skip named registers like "ay
  endif
  let l:lines = copy(v:event.regcontents)
  if v:event.regtype ==# 'V'         " linewise: add the trailing newline
    call add(l:lines, '')
  endif
  call echoraw("\<Esc>]52;c;" .. base64_encode(str2blob(l:lines)) .. "\<Esc>\\")
endfunction

augroup Osc52Clipboard
  autocmd!
  autocmd TextYankPost * call s:Osc52Yank()
augroup END
```

`TextYankPost` fires after every yank/delete; `v:event` describes it. We act
only when `operator` is `y` (a yank) and the register is the unnamed/`+`/`*`
one, then send the yanked lines out as OSC 52.

## Behavior

| Action                         | Result                                                              |
| ------------------------------ | ------------------------------------------------------------------- |
| `y` / `yy` / `yiw`             | into vim's register **and** OSC 52 to the local clipboard           |
| `p`                            | pastes vim's register, instant, never reads the clipboard           |
| `dd` and other deletes         | into vim's register only; does **not** overwrite the clipboard      |
| insert mode `ctrl+shift+v`     | terminal's native paste of the local clipboard (bracketed paste)    |
| `"+p`                          | reads the local x11/wayland clipboard when present (no display: empty) |

## Why not `clipboard=unnamedplus`

With `unnamedplus`, the unnamed register *is* the `+` register, so every `p`
would trigger an OSC 52 **read** of the clipboard -- which is unreliable and
prompts for permission in many terminals. Keeping `clipboard` empty splits
the two concerns: copy goes out via the yank autocmd (reliable write), while
`p` stays a fast, local, in-vim operation.

## Troubleshooting

- **Yank does not reach the clipboard:** confirm tmux has
  `set-clipboard external`, and that the outer terminal allows clipboard
  writes (kitty: `clipboard_control` includes `write-clipboard`).
- **Test the raw escape** from a shell on the remote host:
  ```sh
  printf '\033]52;c;%s\033\\' "$(printf 'hello' | base64)"
  ```
  Then paste on the physical machine; you should get `hello`.
- **Large yanks** may hit terminal/tmux size limits on OSC 52 payloads.
