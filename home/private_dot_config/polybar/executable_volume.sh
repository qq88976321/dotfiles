#!/usr/bin/env sh
# Polybar wireplumber helper.
# Usage: volume.sh output|input get|toggle|up|down
#
# @DEFAULT_AUDIO_SOURCE@ silently falls back to the sink when no default
# source is configured, which makes the input module mirror the output.
# Resolve the real node ID from `wpctl status` instead.
set -eu

kind=${1:?usage: $0 output|input get|toggle|up|down}
action=${2:-get}

case "$kind" in
    output) section='Sinks:' ;;
    input)  section='Sources:' ;;
    *) echo "unknown kind: $kind" >&2; exit 1 ;;
esac

id=$(wpctl status | awk -v sect="$section" '
    $0 ~ sect { f=1; next }
    /endpoints:/ { f=0 }
    f {
        if ($2 == "*") { sub(/\.$/, "", $3); print $3; exit }
        else if ($2 ~ /^[0-9]+\.$/ && !fb) { sub(/\.$/, "", $2); fb = $2 }
    }
    END { if (fb) print fb }
')

if [ -z "$id" ]; then
    [ "$action" = get ] && echo ""
    exit 0
fi

# Nerd Font glyphs — built from raw bytes so this source file stays ASCII-only.
ICON_LOW=$(printf '\xef\xa9\xbe')
ICON_MID=$(printf '\xef\xa9\xbf')
ICON_HIGH=$(printf '\xef\x80\xa8')
ICON_SINK_MUTED=$(printf '\xef\xb1\x9d')
ICON_MIC=$(printf '\xef\x84\xb0')
ICON_MIC_MUTED=$(printf '\xef\x84\xb1')

case "$action" in
    get)
        wpctl get-volume "$id" | awk -v kind="$kind" \
            -v low="$ICON_LOW" -v mid="$ICON_MID" -v high="$ICON_HIGH" \
            -v sm="$ICON_SINK_MUTED" \
            -v mic="$ICON_MIC" -v mmuted="$ICON_MIC_MUTED" '
            /MUTED/ {
                icon = (kind == "output" ? sm : mmuted)
                printf "%%{F#707880}%s muted%%{F-}\n", icon
                exit
            }
            {
                v = $2 * 100
                if (kind == "output") {
                    icon = (v < 34 ? low : (v < 67 ? mid : high))
                    printf "%s %d%%\n", icon, v
                } else {
                    printf "%s %d%%\n", mic, v
                }
            }'
        ;;
    toggle) wpctl set-mute   "$id" toggle ;;
    up)     wpctl set-volume "$id" 5%+ ;;
    down)   wpctl set-volume "$id" 5%- ;;
    *) echo "unknown action: $action" >&2; exit 1 ;;
esac
