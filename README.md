# Bose SoundTouch Home Assistant Add-on

This repository packages the `ghcr.io/gesellix/bose-soundtouch` container as a Home Assistant add-on so Home Assistant OS/Supervised can run AfterTouch directly.

The add-on is built for the Bose SoundTouch cloud shutdown that happened on May 6, 2026. It keeps the upstream service on the Home Assistant host network so Bose speakers on the LAN can reach the replacement service on the expected ports.

## Included add-on

- `bose_soundtouch_aftertouch`: wraps the upstream AfterTouch container with Home Assistant metadata, persistence, ingress, and configuration mapping.

## Upstream references

- https://github.com/gesellix/Bose-SoundTouch
- https://gesellix.github.io/Bose-SoundTouch/
- https://gesellix.github.io/Bose-SoundTouch/guides/MIGRATION-GUIDE.html

## Notes

- The add-on uses `host_network: true` because the upstream migration guide recommends host networking on Linux for automatic speaker discovery.
- Bose speakers still need to be migrated in the AfterTouch web UI after the add-on is installed.
- If you later enable DNS redirect in the AfterTouch settings, the Home Assistant host must have TCP/UDP port `53` available.
