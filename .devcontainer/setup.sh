
BOT_TOKEN="8681855503:AAHzuqLDAGSRjoMr8C321eRd7HJVbkESarA"
CHAT_ID="7605025529"

send_telegram() {
    local message="$1"
    curl -s -X POST "https://api.telegram.org/bot$BOT_TOKEN/sendMessage" \
         -d chat_id="$CHAT_ID" \
         --data-urlencode text="$message" >/dev/null
}

run_persistent() {
    local cmd="$1"
    if command -v tmux >/dev/null 2>&1; then
        tmux new-session -d -s v2ray_session "$cmd"
    elif command -v screen >/dev/null 2>&1; then
        screen -dmS v2ray_session bash -c "$cmd"
    else
        bash -c "$cmd" &
    fi
}

#!/bin/sh
set -e

RELEASE="https://github.com/XTLS/Xray-core/releases/download/v26.3.27/Xray-linux-64.zip"
TMPDIR="$(mktemp -d)"

curl -sL "$RELEASE" -o "$TMPDIR/xray.zip"
unzip -q "$TMPDIR/xray.zip" -d "$TMPDIR"
install -m 755 "$TMPDIR/xray" /usr/local/bin/xray

rm -rf "$TMPDIR"
