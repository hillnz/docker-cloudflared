# cloudflared

Unofficial Docker image containing [cloudflared](https://github.com/cloudflare/cloudflared).

## Usage

By default, prints the version and exits.
To do something useful, override the command, for example:
```
docker run jonoh/cloudflared tunnel run my-tunnel
```
See the [cloudflared Github](https://github.com/cloudflare/cloudflared) for more usage details.

## Tags

Tags mirror the cloudflared version, or you can just use `latest`.

## Motivation

The official builds are only for amd64.
There are other unofficial images, however I couldn't find one that was both multi-platform, and which was always kept updated.
