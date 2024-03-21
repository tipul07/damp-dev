FROM ubuntu/apache2:2.4-22.04_edge
RUN apt-get update

RUN apt-get install -y --no-install-recommends \
        mc ca-certificates

# Forcepoint certificate
COPY files/forcepoint.crt /usr/local/share/ca-certificates/forcepoint.crt
RUN update-ca-certificates

RUN a2enmod rewrite actions expires headers http2 include mime mime_magic proxy_fcgi remoteip ssl userdir
RUN a2dismod status
