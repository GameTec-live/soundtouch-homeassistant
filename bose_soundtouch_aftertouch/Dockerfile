ARG UPSTREAM_VERSION=0.72.0
FROM ghcr.io/gesellix/bose-soundtouch:${UPSTREAM_VERSION}

ARG BUILD_ARCH
ARG BUILD_VERSION

RUN apk add --no-cache jq

COPY run.sh /run.sh
RUN chmod a+x /run.sh

LABEL \
  io.hass.version="${BUILD_VERSION}" \
  io.hass.type="addon" \
  io.hass.arch="armhf|armv7|aarch64|amd64|i386"

ENTRYPOINT ["/run.sh"]
