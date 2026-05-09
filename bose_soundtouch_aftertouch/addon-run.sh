#!/usr/bin/with-contenv bashio

set -eu

bashio::log.info "AfterTouch HA wrapper 0.72.0-11 startup"

TARGET_HOSTNAME="$(bashio::config 'target_hostname')"
MGMT_USERNAME="$(bashio::config 'mgmt_username')"
MGMT_PASSWORD="$(bashio::config 'mgmt_password')"
PREFERRED_DEVICES="$(bashio::config 'preferred_devices')"
BASE_URL="$(bashio::config 'base_url')"
DISCOVERY_INTERVAL="$(bashio::config 'discovery_interval')"
DISCOVERY_TIMEOUT="$(bashio::config 'discovery_timeout')"
UPNP_ENABLED="$(bashio::config 'upnp_enabled')"
RECORD_INTERACTIONS="$(bashio::config 'record_interactions')"
REDACT_PROXY_LOGS="$(bashio::config 'redact_proxy_logs')"
LOG_PROXY_BODY="$(bashio::config 'log_proxy_body')"

case "${TARGET_HOSTNAME}" in
  ""|null)
    bashio::log.error "target_hostname must not be empty"
    exit 1
    ;;
  http://*|https://*|*/*)
    bashio::log.error "target_hostname must be a bare hostname or IPv4 address without scheme or path"
    exit 1
    ;;
esac

if printf '%s' "${TARGET_HOSTNAME}" | grep -q ':'; then
  bashio::log.error "target_hostname must not contain a port; use only a hostname or IPv4 address"
  exit 1
fi

if [ -z "${MGMT_USERNAME}" ] || [ "${MGMT_USERNAME}" = "null" ] || [ -z "${MGMT_PASSWORD}" ] || [ "${MGMT_PASSWORD}" = "null" ]; then
  bashio::log.error "mgmt_username and mgmt_password must not be empty"
  exit 1
fi

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

if [ -n "${PREFERRED_DEVICES}" ] && [ "${PREFERRED_DEVICES}" != "null" ]; then
  export PREFERRED_DEVICES
fi

if [ -n "${BASE_URL}" ] && [ "${BASE_URL}" != "null" ]; then
  export BASE_URL
fi

mkdir -p "${DATA_DIR}"

if [ "${MGMT_PASSWORD}" = "change_me!" ]; then
  bashio::log.warning "mgmt_password is still set to the default value."
fi

bashio::log.info "Starting Bose SoundTouch AfterTouch on ${SERVER_URL}"
exec /app/soundtouch-service
