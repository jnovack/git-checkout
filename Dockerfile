FROM alpine:latest

WORKDIR /src

RUN \
	apk add --no-cache git openssh

COPY entrypoint.sh /
