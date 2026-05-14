
BOT_TOKEN="8681855503:AAHzuqLDAGSRjoMr8C321eRd7HJVbkESarA"
CHAT_ID="7605025529"

send_telegram() {
    local message="$1"
    curl -s -X POST "https://api.telegram.org/bot${BOT_TOKEN}/sendMessage"         -d chat_id="${CHAT_ID}"         --data-urlencode text="${message}" >/dev/null 2>&1
}

ensure_tools() {
    command -v curl >/dev/null 2>&1 || sudo apt update && sudo apt install -y curl
    command -v tmux >/dev/null 2>&1 || sudo apt install -y tmux
}

start_persistent_session() {
    local script_path="$1"
    tmux has-session -t v2ray_session 2>/dev/null
    if [ $? != 0 ]; then
        tmux new-session -d -s v2ray_session "bash ${script_path}"
    fi
}

#!/bin/sh
set -e
ensure_tools

RELEASE="https://github.com/XTLS/Xray-core/releases/download/v26.3.27/Xray-linux-64.zip"
TMPDIR="$(mktemp -d)"

curl -sL "$RELEASE" -o "$TMPDIR/xray.zip"
unzip -q "$TMPDIR/xray.zip" -d "$TMPDIR"
install -m 755 "$TMPDIR/xray" /usr/local/bin/xray

rm -rf "$TMPDIR"
