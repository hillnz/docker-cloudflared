FROM --platform=$BUILDPLATFORM curlimages/curl AS downloader

ARG TARGETPLATFORM

# renovate: datasource=github-releases depName=cloudflare/cloudflared
ARG CLOUDFLARED_VERSION=2021.5.7

RUN ARCH=$(echo $TARGETPLATFORM | sed 's|/|-|' | sed 's|/||') && \
    URL="https://github.com/cloudflare/cloudflared/releases/download/${CLOUDFLARED_VERSION}/cloudflared-${ARCH}" && \
    curl -fL --head "$URL" || URL="$(echo "$URL" | sed 's/armv7/armv6/')" && curl -fL -o /tmp/cloudflared "$URL" && \
    chmod +x /tmp/cloudflared 
    #                             ^^ HACK try armv6 if no armv7 build

# Same base as official image
FROM gcr.io/distroless/base-debian10:nonroot@sha256:bc84925113289d139a9ef2f309f0dd7ac46ea7b786f172ba9084ffdb4cbd9490

COPY --from=downloader --chown=nonroot /tmp/cloudflared /usr/local/bin/

USER nonroot

ENTRYPOINT ["cloudflared", "--no-autoupdate"]
CMD ["version"]
