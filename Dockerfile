FROM alpine:latest

WORKDIR /app

RUN \
	apk add --no-cache git openssh

COPY entrypoint.sh /
