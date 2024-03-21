FROM ubuntu:22.04
ARG DEBIAN_FRONTEND=noninteractive
MAINTAINER Andy <andrei.orghici@nuvei.com>

ENV ONB_PHP_VERSION="8.1"

# Prerequisites
RUN set -eux && \
        apt-get update && apt-get install -y \
        curl apt-utils software-properties-common openssl telnet imagemagick cron mc git zip wget ca-certificates
#		supervisor

# Forcepoint certificate
COPY files/forcepoint.crt /usr/local/share/ca-certificates/forcepoint.crt
RUN wget --no-check-certificate https://srv-ria-ubtmirr.nuvei.local/misc/Nuvei-Root-CA.crt -O /usr/local/share/ca-certificates/Nuvei-Root-CA.crt
RUN update-ca-certificates --fresh

RUN wget https://srv-ria-ubtmirr.nuvei.local/misc/GPG-Keys-Ondrej-Repo/armored-key1.asc -O /etc/apt/trusted.gpg.d/armored-key1.asc
RUN wget https://srv-ria-ubtmirr.nuvei.local/misc/GPG-Keys-Ondrej-Repo/armored-key2.asc -O /etc/apt/trusted.gpg.d/armored-key2.asc
RUN apt-key update

# From PHP 8.0 json library got built-in, so add php${ONB_PHP_VERSION}-json if you use lower version of PHP than 8.0
RUN add-apt-repository https://srv-ria-ubtmirr.nuvei.local/repos/ondrej-php
RUN apt-get update && apt-get install -y \
        php${ONB_PHP_VERSION} php${ONB_PHP_VERSION}-fpm php${ONB_PHP_VERSION}-cli php${ONB_PHP_VERSION}-soap \
        php${ONB_PHP_VERSION}-xml php${ONB_PHP_VERSION}-bcmath php${ONB_PHP_VERSION}-xmlrpc php${ONB_PHP_VERSION}-bz2 php${ONB_PHP_VERSION}-curl \
        php${ONB_PHP_VERSION}-mbstring php${ONB_PHP_VERSION}-gd php${ONB_PHP_VERSION}-intl php${ONB_PHP_VERSION}-mysql php${ONB_PHP_VERSION}-zip \
        php${ONB_PHP_VERSION}-ssh2 php${ONB_PHP_VERSION}-sqlite3 php${ONB_PHP_VERSION}-xdebug
        #php${ONB_PHP_VERSION}-json

# Install composer 2...
RUN curl -sSk https://getcomposer.org/installer | php -- --disable-tls --install-dir=/usr/local/bin --filename=composer

COPY ./files/docker-entrypoint.sh /usr/local/bin/

ENTRYPOINT /usr/local/bin/docker-entrypoint.sh php-fpm ${ONB_PHP_VERSION}
STOPSIGNAL SIGQUIT
