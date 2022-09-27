FROM php:fpm
RUN apt-get update

RUN apt-get install -y --no-install-recommends \
    libfreetype6-dev \
    libicu-dev \
    libjpeg-dev \
    #libmagickwand-dev \
    libpng-dev \
    libwebp-dev \
    libzip-dev \
    libxml2-dev \
	libbz2-dev \
	libxslt1-dev \
	#libcurl4-openssl-dev \
	apt-utils software-properties-common openssl telnet

RUN curl -fsSL https://deb.nodesource.com/setup_lts.x | bash -

RUN set -eux && \
        apt-get install -y \
        imagemagick cron mc git nodejs zip
		
RUN docker-php-ext-install -j "$(nproc)" \
    soap \
	#curl \
	#ssh2 \
	pdo \
    pdo_mysql \
    mysqli \
	# sqlite3 \ (Already exists)
	# mbstring \
    bcmath \
    exif \
    gd \
    intl \
    zip \
	bz2 \
	#xmlrpc \
	xsl \
	xml

RUN docker-php-ext-configure gd \
    --with-freetype \
    --with-jpeg \
    --with-webp

#RUN pecl install xdebug && docker-php-ext-enable xdebug

#RUN pecl install imagick-3.7.0 && docker-php-ext-enable imagick

RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer

RUN set -eux; \
docker-php-ext-enable opcache; \
{ \
echo 'opcache.memory_consumption=128'; \
echo 'opcache.interned_strings_buffer=8'; \
echo 'opcache.max_accelerated_files=4000'; \
echo 'opcache.revalidate_freq=2'; \
echo 'opcache.fast_shutdown=1'; \
} > /usr/local/etc/php/conf.d/opcache-recommended.ini
