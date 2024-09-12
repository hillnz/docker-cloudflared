# DEPRECATED

This image is deprecated because Cloudflare provides official arm64 builds now. The repo will be kept alive to allow Renovate's auto-updates to run but no further changes will be made.

# cloudflared

Unofficial Docker image containing [cloudflared](https://github.com/cloudflare/cloudflared).

## Usage

By default, prints the version and exits.
To do something useful, override the command, for example:
```
docker run jonoh/cloudflared tunnel run my-tunnel
```

### Environment Variables

You can see cloudflared's supported environment variables by running `cloudflared [<subcommand>] --help`.

In addition, these custom environment variables are supported. 
If all of them are set (and the command isn't overridden) then the image will execute `cloudflared tunnel run` with the configuration specified.

Name            | Description
---             | ---
ACCOUNT_ID      | Cloudflare Account ID
TUNNEL_ID       | Tunnel ID
TUNNEL_NAME     | Tunnel Name
TUNNEL_SECRET   | Tunnel Secret
PUID            | User ID for the daemon (see Volumes)
PGID            | Group ID for the daemon (see Volumes)

### Volumes

Mount `/config` so that cloudflared's configuration file can be saved.

The daemon runs as a user with id 65532 (like the official image). If this causes permission errors, you can override the uid by setting the PUID environment variable, or the gid by setting the PGID environment variable.

### Example

Using docker-compose:
```yaml
services:
    cloudflared:
        image: jonoh/cloudflared
        environment:
            - PUID=1000
            - PGID=1000
            - ACCOUNT_ID=d41d8cd98f00b204e9800998ecf8427e
            - TUNNEL_ID=2e7d56f0-d51e-4c14-9330-5707b45d0813
            - TUNNEL_NAME=helloworld
            - TUNNEL_SECRET=aGVsbG93b3JsZF9oZWxsb3dvcmxkX2hlbGxvd29ybGQK
            - TUNNEL_URL=http://some_service:8080
        volumes:
            - ./config:/config
```

## Tags

Tags mirror the cloudflared version, or you can just use `latest`.

## Motivation

The official builds are only for amd64.
There are other unofficial images, however I couldn't find one that was both multi-platform, and which was always kept updated.
