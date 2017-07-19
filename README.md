# docker-git-checkout

## Usage

This container was designed as a builder container within a
[multi-stage build](https://docs.docker.com/engine/userguide/eng-image/multistage-build/).

```
FROM jnovack/git-checkout as builder

# Set environment variables
ENV REPO="http://github.com/jnovack/docker-git-checkout.git"
ENV BRANCH="master"
ENV HASH="HEAD"
RUN /entrypoint.sh


FROM alpine:latest
COPY --from=builder /src /app
```

### Environment Variables

* `REPO` - (string, required) A http(s):// or ssh:// git repository url
* `BRANCH` - (string, optional) The name of your branch to download.
_Default:_ `master`
* `HASH` - (string, optional) The hash of the commit. _Default:_ `HEAD`
* `SSH_PRIVATE_KEY` - (string, optional) SSH private key for authenticated
repository download
