# git-checkout

A tiny builder container for pulling source from git.

## Usage

This container was designed as a builder container within a
[multi-stage build](https://docs.docker.com/engine/userguide/eng-image/multistage-build/).

```Dockerfile
## Build Container
FROM jnovack/git-checkout as builder

### Set environment variables
ENV REPO="http://github.com/jnovack/git-checkout.git"
ENV BRANCH="master"
ENV HASH="HEAD"
RUN /checkout.sh

## Application Container
FROM alpine:latest
COPY --from=builder /src /app
```

## Environment Variables

### `REPO`

*(string, required)*

A `http(s)://` or `ssh://` git repository url.

### `BRANCH`

*(string, optional)*

The name of your branch to download. (_Default:_ `master`)

### `HASH`

*(string, optional)*

The hash of the commit. (_Default:_ `HEAD`)

### `SSH_KEY`

*(string, optional, supports _FILE)*

SSH private key for authenticated repository download.  `SSH_KEY` will always
override `SSH_KEY_FILE`, if provided.

#### `SSH_KEY_FILE`

In the event you wish to store the key in Docker Secrets, or you want to mount
in the file directly, you can set this to the file path within the container.

```Dockerfile
## Build Container
FROM jnovack/git-checkout as builder

### Set environment variables
ENV REPO="http://github.com/jnovack/git-checkout.git"
ENV BRANCH="master"
ENV HASH="HEAD"
ENV SSH_KEY_FILE="/id_rsa"
COPY ~/.ssh/id_rsa /id_rsa
RUN /checkout.sh

## Application Container
FROM alpine:latest
COPY --from=builder /src /app
```
