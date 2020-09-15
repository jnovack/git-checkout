FROM alpine:latest

WORKDIR /src

RUN \
	apk add --no-cache git openssh

COPY checkout.sh /

ENV USER=appuser
ENV UID=10001
RUN adduser \
	--disabled-password \
	--gecos "" \
	--home "/home/${USER}" \
	--shell "/sbin/nologin" \
	--uid "${UID}" \
	"${USER}"
USER appuser:appuser

ENTRYPOINT [ "/checkout.sh" ]
