FROM ubuntu:22.04
ARG DEBIAN_FRONTEND=noninteractive
MAINTAINER Andy <andrei.orghici@nuvei.com>

RUN set -eux && \
        apt-get update && apt-get install -y \
        curl apt-utils software-properties-common openssl telnet ca-certificates imagemagick cron mc git zip

# Forcepoint certificate
COPY files/forcepoint.crt /usr/local/share/ca-certificates/forcepoint.crt
RUN update-ca-certificates

# In PHP 8.0 json library got built-in, so add php${ONB_PHP_VERSION}-json if you use lower version of PHP than 8.0
RUN add-apt-repository ppa:ondrej/php && apt-get update && apt-get install -y \
        php${ONB_PHP_VERSION} php${ONB_PHP_VERSION}-fpm php${ONB_PHP_VERSION}-cli php${ONB_PHP_VERSION}-soap \
        php${ONB_PHP_VERSION}-xml php${ONB_PHP_VERSION}-bcmath php${ONB_PHP_VERSION}-xmlrpc php${ONB_PHP_VERSION}-bz2 php${ONB_PHP_VERSION}-curl \
        php${ONB_PHP_VERSION}-mbstring php${ONB_PHP_VERSION}-gd php${ONB_PHP_VERSION}-intl php${ONB_PHP_VERSION}-mysql php${ONB_PHP_VERSION}-zip \
        php${ONB_PHP_VERSION}-ssh2 php${ONB_PHP_VERSION}-sqlite3
        #php${ONB_PHP_VERSION}-json

# Install composer 2...
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer

COPY ./files/docker-entrypoint.sh /usr/local/bin/

ENTRYPOINT docker-entrypoint.sh php-fpm ${ONB_PHP_VERSION}
STOPSIGNAL SIGQUIT
