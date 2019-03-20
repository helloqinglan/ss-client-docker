#
# Dockerfile for shadowsocks-libev client
#

FROM alpine

ENV SERVER_ADDR 0.0.0.0
ENV SERVER_PORT 8388
ENV LOCAL_ADDR  0.0.0.0
ENV LOCAL_PORT  1080
ENV PASSWORD=
ENV METHOD      aes-256-gcm
ENV TIMEOUT     300
ENV DNS_ADDRS    8.8.8.8,8.8.4.4
ENV ARGS=

COPY . /tmp/repo
COPY docker-entrypoint.sh /

RUN set -ex \
 # Build environment setup
 && apk update \
 && apk add --no-cache --virtual .build-deps \
      autoconf \
      automake \
      build-base \
      c-ares-dev \
      libev-dev \
      libtool \
      libsodium-dev \
      linux-headers \
      mbedtls-dev \
      pcre-dev \
      curl \
      tar \
      gettext-dev \
      openssl-dev \
 # Build & install
 && cd /tmp/repo \
 && tar -xzf shadowsocks-libev-3.2.5.tar.gz --strip 1 \
 && ./configure --prefix=/usr --disable-documentation \
 && make install \
 && apk del .build-deps \
 # Runtime dependencies setup
 && apk add --no-cache \
      rng-tools \
      $(scanelf --needed --nobanner /usr/bin/ss-* \
      | awk '{ gsub(/,/, "\nso:", $2); print "so:" $2 }' \
      | sort -u) \
 && rm -rf /tmp/repo

USER nobody

EXPOSE $LOCAL_PORT/tcp

ENTRYPOINT sh /docker-entrypoint.sh
