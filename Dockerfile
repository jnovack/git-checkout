FROM alpine:latest

WORKDIR /website
VOLUME /website
ENTRYPOINT ["/entrypoint.sh"]
COPY entrypoint.sh /

RUN \
	apk add --no-cache git openssh && \
	mkdir -p /website
