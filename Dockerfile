FROM --platform=$BUILDPLATFORM curlimages/curl AS downloader

ARG TARGETPLATFORM

# renovate: datasource=github-releases depName=cloudflare/cloudflared
ARG CLOUDFLARED_VERSION=2021.9.2

RUN download() { \
        URL="https://github.com/cloudflare/cloudflared/releases/download/${CLOUDFLARED_VERSION}/cloudflared-$1" && \
        echo "URL: $URL" && \
        curl -fL -o /tmp/cloudflared "$URL"; \
    }; \
    ARCH=$(echo $TARGETPLATFORM | sed 's|/|-|' | sed 's|/||') && \
    download "$ARCH" || download "$(echo "$ARCH" | sed 's/armv7/arm/')" && \
    chmod +x /tmp/cloudflared     
    #                               ^^ HACK try arm if no armv7 build
    

FROM debian:11.0-slim

RUN apt-get update && apt-get install -y \
        jq \
    && rm -rf /var/lib/apt/lists

COPY --from=downloader --chown=nonroot /tmp/cloudflared /usr/local/bin/

# a la old image version's distroless
RUN ln -s /home/nonroot /config && \
    useradd -U -u 65532 -d /config -s /bin/false nonroot
USER nonroot

COPY entrypoint.sh /

ENTRYPOINT [ "/entrypoint.sh" ]
