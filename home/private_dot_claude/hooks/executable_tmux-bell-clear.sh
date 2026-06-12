#!/bin/sh
# Called from the tmux session-window-changed hook with the current window id.
# Strips the trailing bell emoji (added by the Claude Code Stop hook) from the
# window name once the user switches to that window.
#
# Prefer the self-built tmux (the aqua prebuilt build has broken OSC 52), but
# fall back to whatever tmux is on PATH for machines without it.
TMUX_BIN=/usr/local/bin/tmux
[ -x "$TMUX_BIN" ] || TMUX_BIN=tmux
b=$(printf '\360\237\224\224')
w=$("$TMUX_BIN" display-message -p -t "$1" '#W') || exit 0
case "$w" in
  *"$b") "$TMUX_BIN" rename-window -t "$1" "${w%"$b"}" ;;
esac
