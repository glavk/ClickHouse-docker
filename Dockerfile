FROM debian:stable-slim

ENV DEBIAN_FRONTEND=noninteractive
ARG gosu_ver=1.14

WORKDIR /opt
RUN apt-get update && apt-get install wget locales --yes
RUN wget --progress=bar:force:noscroll 'https://builds.clickhouse.tech/master/aarch64/clickhouse' \
    && chmod +x clickhouse && ./clickhouse install \
    && rm clickhouse && rm -rf \
        /var/lib/apt/lists/* \
        /var/cache/debconf \
        /tmp/* \
    && apt-get clean

ADD https://github.com/tianon/gosu/releases/download/${gosu_ver}/gosu-arm64 /bin/gosu

ENV LANG en_US.UTF-8
ENV LANGUAGE en_US:en
ENV LC_ALL en_US.UTF-8
ENV TZ UTC

## BUG: /bin/bash: warning: setlocale: LC_ALL: cannot change locale (en_US.UTF-8)
RUN locale-gen en_US.UTF-8
#&& dpkg-reconfigure locales

RUN mkdir /docker-entrypoint-initdb.d

COPY docker_related_config.xml /etc/clickhouse-server/config.d/
COPY entrypoint.sh /entrypoint.sh
RUN chmod +x \
    /entrypoint.sh \
    /bin/gosu

EXPOSE 9000 8123 9009
VOLUME /var/lib/clickhouse

ENV CLICKHOUSE_CONFIG /etc/clickhouse-server/config.xml

ENTRYPOINT ["/entrypoint.sh"]