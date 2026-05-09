ARG BUILD_FROM=ghcr.io/home-assistant/base:latest
ARG UPSTREAM_VERSION=0.72.0
FROM ghcr.io/gesellix/bose-soundtouch:${UPSTREAM_VERSION} AS upstream

FROM ${BUILD_FROM}

ARG BUILD_ARCH
ARG BUILD_VERSION

RUN apk add --no-cache jq

RUN mkdir -p /app
COPY --from=upstream /app/soundtouch-service /app/soundtouch-service
COPY addon-run.sh /addon-run.sh
RUN chmod a+x /app/soundtouch-service /addon-run.sh

LABEL \
  io.hass.version="${BUILD_VERSION}" \
  io.hass.type="addon" \
  io.hass.arch="armhf|armv7|aarch64|amd64|i386"

CMD ["/addon-run.sh"]
