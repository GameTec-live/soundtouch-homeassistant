# Bose SoundTouch AfterTouch

Run the upstream Bose SoundTouch AfterTouch service inside Home Assistant so SoundTouch devices can keep working after the Bose cloud shutdown on May 6, 2026.

This add-on is a thin Home Assistant wrapper around `ghcr.io/gesellix/bose-soundtouch`. It keeps the upstream web UI and data model, but adds:

- Home Assistant add-on metadata
- Home Assistant-managed persistence
- Host networking for Bose device discovery on Linux
- Ingress and a direct web UI link

See `DOCS.md` for setup and migration steps.
