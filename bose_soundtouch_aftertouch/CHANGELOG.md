# Changelog

## 0.72.0-9

- Renamed the Home Assistant wrapper version back into the `0.72.x` line
- Kept the upstream image pinned to `ghcr.io/gesellix/bose-soundtouch:0.72.0`

## 0.72.0-8

- Fixed startup handling for `null`/missing required options so validation errors are explicit

## 0.72.0-7

- Set `init: false` as required by the official Home Assistant app docs for custom images with their own init/entrypoint
- Removed the default `target_hostname` so users must explicitly set a LAN-reachable host value in Home Assistant

## 0.72.0-6

- Removed the remaining hard dependency on `/data/options.json` during startup
- Added an explicit Home Assistant `data` mount at `/data` for clearer persistence behavior

## 0.72.0-5

- Added a Supervisor API fallback for app options when `/data/options.json` is not present at startup
- Added default option generation as a last-resort startup fallback

## 0.72.0-4

- Fixed Home Assistant options loading by restoring the default `/data` add-on mount
- Moved upstream AfterTouch state into `/data/aftertouch` inside the add-on

## 0.72.0-3

- Added `armv7` back for 32-bit Raspberry Pi/Home Assistant installs that still need it
- Kept `aarch64` for supported Raspberry Pi 4/5 64-bit installs

## 0.72.0-2

- Fixed Home Assistant `webui` placeholder syntax so Supervisor accepts the app metadata
- Removed deprecated 32-bit Home Assistant architectures from the published app manifest

## 0.72.0-1

- Rebased the add-on wrapper onto upstream Bose SoundTouch `v0.72.0`
- Updated the pinned upstream container image to `ghcr.io/gesellix/bose-soundtouch:0.72.0`

## 0.70.0-1

- Initial Home Assistant add-on wrapper for the upstream Bose SoundTouch AfterTouch container
- Added host-network deployment for Linux/Home Assistant discovery
- Added Home Assistant ingress, persistence, and option-to-environment mapping
