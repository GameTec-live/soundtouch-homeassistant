# Bose SoundTouch AfterTouch

This add-on runs the upstream `soundtouch-service` from the Bose SoundTouch Toolkit inside Home Assistant.

## Why this add-on uses host networking

The upstream migration guide recommends host networking on Linux for automatic speaker discovery. Home Assistant OS and Supervised both run on Linux, so this add-on uses `host_network: true` to match that deployment model.

That choice also keeps the service reachable on the LAN for Bose speakers at:

- `http://<home-assistant-host>:8000`
- `https://<home-assistant-host>:8443`

If you later enable DNS redirect inside AfterTouch, the service will also need TCP/UDP port `53` on the Home Assistant host.

## Installation

1. Add this repository to Home Assistant or copy the add-on folder into your local `/addons` directory.
2. Install `Bose SoundTouch AfterTouch`.
3. Set `target_hostname` to the LAN hostname or IPv4 address your Bose speakers can reach.
4. Change `mgmt_password` from the default.
5. Start the add-on.
6. Open the add-on web UI or ingress panel.

## Configuration

- `target_hostname`: Bare hostname or IPv4 address for your Home Assistant host. Do not include `http://`, `https://`, or a port.
- `mgmt_username`: Username for upstream management endpoints.
- `mgmt_password`: Password for upstream management endpoints.
- `preferred_devices`: Optional semicolon-separated list in upstream format, for example `Living Room@192.168.1.10;Kitchen@192.168.1.11`.
- `base_url`: Optional external base URL for reverse-proxy or OAuth callback use cases.
- `discovery_interval`: Device discovery polling interval.
- `discovery_timeout`: Discovery timeout passed to the upstream container.
- `upnp_enabled`: Enables upstream UPnP-based discovery features.
- `record_interactions`: Stores request/response interaction history for troubleshooting and migration checks.
- `redact_proxy_logs`: Redacts sensitive values from logs.
- `log_proxy_body`: Logs proxy bodies. Leave disabled unless you are actively debugging.

## What this add-on does not automate

The add-on deploys the AfterTouch service correctly in Home Assistant, but Bose speakers still need the upstream migration workflow:

1. Open the AfterTouch UI.
2. Discover or manually add each speaker.
3. Enable SSH on each speaker with the `remote_services` USB method if migration needs it.
4. Sync device data.
5. Run either XML redirect or DNS/DHCP redirect from the migration UI.
6. Reboot each speaker and verify presets, recents, and playback.

The upstream migration guide recommends XML redirect first for testing, and DNS/DHCP redirect for the permanent setup.

## Operational notes

- The add-on persists all upstream data in the Home Assistant add-on data directory mapped to `/app/data`.
- The upstream docs note that `data/settings.json` overrides environment variables after you change settings in the web UI.
- If `target_hostname` is wrong, migration checks in the AfterTouch UI will fail because speakers cannot reach the service.
- If port `53`, `8000`, or `8443` is already in use on the Home Assistant host, the add-on cannot start correctly.

## Upstream documentation

- Project: https://github.com/gesellix/Bose-SoundTouch
- Docs: https://gesellix.github.io/Bose-SoundTouch/
- Migration guide: https://gesellix.github.io/Bose-SoundTouch/guides/MIGRATION-GUIDE.html
