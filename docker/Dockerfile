FROM alpine:3.16.3

RUN apk add --no-cache dhcp
VOLUME /etc/bind

CMD ["dhcpd", "-4", "-d", "-cf", "/etc/dhcp/dhcpd.conf"]