FROM --platform=$BUILDPLATFORM curlimages/curl AS downloader

ARG TARGETPLATFORM

# renovate: datasource=github-releases depName=cloudflare/cloudflared
ARG CLOUDFLARED_VERSION=2021.6.0

RUN ARCH=$(echo $TARGETPLATFORM | sed 's|/|-|' | sed 's|/||') && \
    URL="https://github.com/cloudflare/cloudflared/releases/download/${CLOUDFLARED_VERSION}/cloudflared-${ARCH}" && \
    curl -fL --head "$URL" || URL="$(echo "$URL" | sed 's/armv7/armv6/')" && curl -fL -o /tmp/cloudflared "$URL" && \
    chmod +x /tmp/cloudflared 
    #                             ^^ HACK try armv6 if no armv7 build

# Same base as official image
FROM gcr.io/distroless/base-debian10:nonroot@sha256:38778ff7aa549bf6904c9d1c68bfe5946e96cac91dc32ba1f58e83bb9c9e6abe

COPY --from=downloader --chown=nonroot /tmp/cloudflared /usr/local/bin/

USER nonroot

ENTRYPOINT ["cloudflared", "--no-autoupdate"]
CMD ["version"]
