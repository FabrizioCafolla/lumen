FROM php:7.4.3-fpm-alpine

LABEL mantainer="developer@fabriziocafolla.com"
LABEL description="Production container"

ENV build_deps \
		autoconf \
        libzip-dev \
        curl-dev \
        oniguruma-dev 

ENV persistent_deps \
		build-base \
        git \
		unzip \
        curl \
        g++ \
        gcc \
        make \
        mysql-client \
        php-xml \
        php-zip \
        rsync

# Set working directory as
WORKDIR /var/www

# Add permission to workdir
RUN chown -R www-data:www-data ./* \
    && chown -R www-data:www-data ./.* \
    && find . -type f -exec chmod 644 {} \; \
    && find . -type d -exec chmod 775 {} \; 

# Install build dependencies
RUN apk upgrade && apk update && \
    apk add --no-cache --virtual .build-dependencies $build_deps

# Install persistent dependencies
RUN apk add --update --no-cache --virtual .persistent-dependencies $persistent_deps \
    && curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer

# Install docker ext and remove build deps
RUN apk update \
    && docker-php-ext-configure zip \
    && docker-php-ext-install mysqli \
        pdo \
        pdo_mysql \
        bcmath \
        curl \
        pcntl \
        zip \
        exif \
    && apk del -f .build-dependencies

# Change current user to www
USER www-data

CMD ["php-fpm", "--nodaemonize"]
