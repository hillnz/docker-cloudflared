FROM --platform=$BUILDPLATFORM curlimages/curl AS downloader

ARG TARGETPLATFORM

# renovate: datasource=github-releases depName=cloudflare/cloudflared
ARG CLOUDFLARED_VERSION=2021.7.4

RUN ARCH=$(echo $TARGETPLATFORM | sed 's|/|-|' | sed 's|/||') && \
    URL="https://github.com/cloudflare/cloudflared/releases/download/${CLOUDFLARED_VERSION}/cloudflared-${ARCH}" && \
    curl -fL --head "$URL" || URL="$(echo "$URL" | sed 's/armv7/arm/')" && curl -fL -o /tmp/cloudflared "$URL" && \
    chmod +x /tmp/cloudflared 
    #                             ^^ HACK try armv6 if no armv7 build

# Same base as official image
FROM gcr.io/distroless/base-debian10:nonroot@sha256:ccbc79c4fc35b92709d3987315cdb9e20b6e742546af7a7db10024641aa60572

COPY --from=downloader --chown=nonroot /tmp/cloudflared /usr/local/bin/

USER nonroot

ENTRYPOINT ["cloudflared", "--no-autoupdate"]
CMD ["version"]
