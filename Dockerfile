FROM alpine:latest

WORKDIR /app
VOLUME /app
ENTRYPOINT ["/entrypoint.sh"]
COPY entrypoint.sh /

RUN \
	apk add --no-cache git openssh && \
	mkdir -p /app

