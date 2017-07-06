FROM alpine:latest

RUN mkdir -p /app

WORKDIR /app

ENTRYPOINT ["/entrypoint.sh"]

RUN apk add --update --no-cache git openssh

COPY entrypoint.sh /
