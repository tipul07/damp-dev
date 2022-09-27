FROM ubuntu/apache2:latest
RUN apt-get update

RUN apt-get install -y --no-install-recommends \
        mc

RUN a2enmod rewrite actions expires headers http2 include mime mime_magic proxy_fcgi remoteip ssl userdir
RUN a2dismod status
