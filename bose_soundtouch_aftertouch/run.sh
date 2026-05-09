#!/bin/sh
set -eu

CONFIG_PATH=/data/options.json
CONFIG_JSON=

DEFAULT_CONFIG_JSON='{
  "target_hostname": null,
  "mgmt_username": "admin",
  "mgmt_password": "change_me!",
  "preferred_devices": "",
  "base_url": "",
  "discovery_interval": "5m",
  "discovery_timeout": "5s",
  "upnp_enabled": true,
  "record_interactions": true,
  "redact_proxy_logs": true,
  "log_proxy_body": false
}'

load_config() {
  if [ -s "$CONFIG_PATH" ]; then
    CONFIG_JSON="$(cat "$CONFIG_PATH")"
    return
  fi

  mkdir -p /data

  if [ -n "${SUPERVISOR_TOKEN:-}" ]; then
    RESPONSE_FILE="$(mktemp)"
    if curl -fsS \
      -H "Authorization: Bearer ${SUPERVISOR_TOKEN}" \
      http://supervisor/addons/self/info \
      >"$RESPONSE_FILE"; then
      if CONFIG_JSON="$(jq -cer '.data.options // .options' "$RESPONSE_FILE")"; then
        printf '%s\n' "$CONFIG_JSON" >"$CONFIG_PATH" 2>/dev/null || true
        rm -f "$RESPONSE_FILE"
        return
      fi
    fi
    rm -f "$RESPONSE_FILE"
  fi

  echo "Warning: app options could not be loaded from /data/options.json or Supervisor API; using defaults." >&2
  CONFIG_JSON="$DEFAULT_CONFIG_JSON"
  printf '%s\n' "$CONFIG_JSON" >"$CONFIG_PATH" 2>/dev/null || true
}

get_string() {
  printf '%s' "$CONFIG_JSON" | jq -er --arg key "$1" '.[$key] // empty'
}

get_bool() {
  printf '%s' "$CONFIG_JSON" | jq -er --arg key "$1" '.[$key]'
}

load_config

TARGET_HOSTNAME="$(get_string target_hostname || true)"
MGMT_USERNAME="$(get_string mgmt_username || true)"
MGMT_PASSWORD="$(get_string mgmt_password || true)"

if [ -z "$TARGET_HOSTNAME" ]; then
  echo "target_hostname must not be empty" >&2
  exit 1
fi

case "$TARGET_HOSTNAME" in
  http://*|https://*|*/*)
    echo "target_hostname must be a bare hostname or IPv4 address without scheme or path" >&2
    exit 1
    ;;
esac

if printf '%s' "$TARGET_HOSTNAME" | grep -q ':'; then
  echo "target_hostname must not contain a port; use only a hostname or IPv4 address" >&2
  exit 1
fi

if [ -z "$MGMT_USERNAME" ] || [ -z "$MGMT_PASSWORD" ]; then
  echo "mgmt_username and mgmt_password must not be empty" >&2
  exit 1
fi

PREFERRED_DEVICES="$(get_string preferred_devices || true)"
BASE_URL="$(get_string base_url || true)"
DISCOVERY_INTERVAL="$(get_string discovery_interval || true)"
DISCOVERY_TIMEOUT="$(get_string discovery_timeout || true)"
UPNP_ENABLED="$(get_bool upnp_enabled)"
RECORD_INTERACTIONS="$(get_bool record_interactions)"
REDACT_PROXY_LOGS="$(get_bool redact_proxy_logs)"
LOG_PROXY_BODY="$(get_bool log_proxy_body)"

export PORT=8000
export HTTPS_PORT=8443
export DATA_DIR=/data/aftertouch
export SERVER_URL="http://${TARGET_HOSTNAME}:8000"
export HTTPS_SERVER_URL="https://${TARGET_HOSTNAME}:8443"
export SOUNDTOUCH_HOSTNAME="${TARGET_HOSTNAME}"
export MGMT_USERNAME
export MGMT_PASSWORD
export DISCOVERY_INTERVAL
export DISCOVERY_TIMEOUT
export UPNP_ENABLED
export RECORD_INTERACTIONS
export REDACT_PROXY_LOGS
export LOG_PROXY_BODY

if [ -n "${PREFERRED_DEVICES}" ]; then
  export PREFERRED_DEVICES
fi

if [ -n "${BASE_URL}" ]; then
  export BASE_URL
fi

mkdir -p "$DATA_DIR"

if [ "$MGMT_PASSWORD" = "change_me!" ]; then
  echo "Warning: mgmt_password is still set to the default value." >&2
fi

echo "Starting Bose SoundTouch AfterTouch on ${SERVER_URL}" >&2
exec /app/soundtouch-service
