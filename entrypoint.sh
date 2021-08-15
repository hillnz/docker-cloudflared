#!/usr/bin/env bash

set -e

if [ -z "$TUNNEL_CRED_FILE" ]; then
    TUNNEL_CRED_FILE="/config/.cloudflared/${TUNNEL_ID}.json"
fi

make_config() {
    if [ -f "$CONF_FILE" ]; then
        return
    fi
    mkdir -p "$(dirname "$CONF_FILE")"
    # shellcheck disable=SC2016
    echo '{}' | jq \
        --arg ACCOUNT_ID "$ACCOUNT_ID" \
        --arg TUNNEL_ID "$TUNNEL_ID" \
        --arg TUNNEL_NAME "$TUNNEL_NAME" \
        --arg TUNNEL_SECRET "$TUNNEL_SECRET" \
        '.AccountTag = $ACCOUNT_ID | .TunnelID = $TUNNEL_ID | .TunnelName = $TUNNEL_NAME | .TunnelSecret = $TUNNEL_SECRET' \
        >"$CONF_FILE"
}

args=()
if [ "$1" = "" ]; then
    if [ -n "$ACCOUNT_ID" ] && [ -n "$TUNNEL_ID" ] && [ -n "$TUNNEL_NAME" ] && [ -n "$TUNNEL_SECRET" ]; then
        make_config
        args=(tunnel run "$TUNNEL_ID")
    else
        args+=(version)
    fi
else
    args=("$@")
fi

exec cloudflared --no-autoupdate "${args[@]}"
