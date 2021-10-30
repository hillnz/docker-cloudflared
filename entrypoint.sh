#!/usr/bin/env bash

set -e

groupmod -o -g "$PUID" nonroot
usermod -o -u "$PUID" nonroot

if [ -z "$TUNNEL_CRED_FILE" ]; then
    TUNNEL_CRED_FILE="/config/.cloudflared/${TUNNEL_ID}.json"
fi

make_config() {
    if [ -f "$TUNNEL_CRED_FILE" ]; then
        return
    fi

    config_dir=$(dirname "$TUNNEL_CRED_FILE")
    mkdir "$config_dir"
    
    # shellcheck disable=SC2016
    echo '{}' | jq \
        --arg ACCOUNT_ID "$ACCOUNT_ID" \
        --arg TUNNEL_ID "$TUNNEL_ID" \
        --arg TUNNEL_NAME "$TUNNEL_NAME" \
        --arg TUNNEL_SECRET "$TUNNEL_SECRET" \
        '.AccountTag = $ACCOUNT_ID | .TunnelID = $TUNNEL_ID | .TunnelName = $TUNNEL_NAME | .TunnelSecret = $TUNNEL_SECRET' \
        >"$TUNNEL_CRED_FILE"
    
    chown -R "nonroot:nonroot" "$config_dir"
}

args=()
if [ "$1" = "" ]; then
    if [ -n "$ACCOUNT_ID" ] && [ -n "$TUNNEL_ID" ] && [ -n "$TUNNEL_NAME" ] && [ -n "$TUNNEL_SECRET" ]; then
        make_config
        args=(tunnel run "$TUNNEL_ID")
        args+=("$@")
    else
        args+=(version)
    fi
else
    args=("$@")
fi

exec sudo --preserve-env --set-home -u nonroot cloudflared --no-autoupdate "${args[@]}"
