FROM php:8.3-fpm

ARG DEBIAN_FRONTEND=noninteractive
ARG NODE_MAJOR=23

# Prequisites
RUN apt-get update && apt-get install -y apt-utils
RUN apt-get upgrade -y
RUN apt-get install -y ca-certificates curl gnupg apt-transport-https vim unixodbc unixodbc-dev gpg

# Add NodeJS repository
RUN mkdir -p /etc/apt/keyrings
RUN curl -fsSL https://deb.nodesource.com/gpgkey/nodesource-repo.gpg.key | gpg --dearmor -o /etc/apt/keyrings/nodesource.gpg
RUN echo "deb [signed-by=/etc/apt/keyrings/nodesource.gpg] https://deb.nodesource.com/node_$NODE_MAJOR.x nodistro main" | tee /etc/apt/sources.list.d/nodesource.list

# Install NodeJS
RUN apt-get update && apt-get install -y nodejs

# Add Yarn repository
RUN curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add -
RUN echo "deb https://dl.yarnpkg.com/debian/ stable main" | tee /etc/apt/sources.list.d/yarn.list

# PHP setup prerequisites
RUN apt-get update && apt-get upgrade -y
RUN apt-get install -y \
        g++ \
        git \
        libonig-dev \
        libzip-dev \
        libbz2-dev \
        libc-client-dev \
        libcurl4-gnutls-dev \
        libedit-dev \
        libfreetype6-dev \
        libicu-dev \
        libjpeg62-turbo-dev \
        libkrb5-dev \
        libldap2-dev \
        libmagickwand-dev \
        libmcrypt-dev \
        libmemcached-dev \
        libpq-dev \
        libsodium-dev \
        libsqlite3-dev \
        libssl-dev \
        libreadline-dev \
        libxml2-dev \
        libxslt1-dev \
        librabbitmq-dev \
        wget \
        unzip \
        zlib1g-dev \
        nodejs \
        yarn \
        iputils-ping \
        locales

# PHP AMQP
RUN pecl install amqp && docker-php-ext-enable amqp

# PHP setup extensions
RUN docker-php-ext-configure gd --with-freetype --with-jpeg && docker-php-ext-install -j$(nproc) gd \
    && docker-php-ext-configure imap --with-kerberos --with-imap-ssl && docker-php-ext-install -j$(nproc) imap \
    && docker-php-ext-configure intl && docker-php-ext-install -j$(nproc) intl \
    && docker-php-ext-configure ldap && docker-php-ext-install ldap

RUN docker-php-ext-install -j$(nproc) bcmath
RUN docker-php-ext-install -j$(nproc) bz2
RUN docker-php-ext-install -j$(nproc) calendar
RUN docker-php-ext-install -j$(nproc) ctype
RUN docker-php-ext-install -j$(nproc) curl
RUN docker-php-ext-install -j$(nproc) fileinfo
RUN docker-php-ext-install -j$(nproc) ftp
RUN docker-php-ext-install -j$(nproc) gettext
RUN docker-php-ext-install -j$(nproc) iconv
RUN docker-php-ext-install -j$(nproc) intl
RUN docker-php-ext-install -j$(nproc) mbstring
RUN docker-php-ext-install -j$(nproc) mysqli
RUN docker-php-ext-install -j$(nproc) pdo_mysql
RUN docker-php-ext-install -j$(nproc) pdo_pgsql
RUN docker-php-ext-install -j$(nproc) pdo_sqlite
RUN docker-php-ext-install -j$(nproc) phar
RUN docker-php-ext-install -j$(nproc) pgsql
RUN docker-php-ext-install -j$(nproc) soap
RUN docker-php-ext-install -j$(nproc) sockets
RUN docker-php-ext-install -j$(nproc) sodium
RUN docker-php-ext-install -j$(nproc) xml
RUN docker-php-ext-install -j$(nproc) xmlwriter
RUN docker-php-ext-install -j$(nproc) xsl
RUN docker-php-ext-install -j$(nproc) zip
RUN pecl install mongodb && docker-php-ext-enable mongodb
RUN pecl install memcached && docker-php-ext-enable memcached
RUN pecl install redis && docker-php-ext-enable redis
# RUN yes '' | pecl install imagick && docker-php-ext-enable imagick
RUN docker-php-source delete
RUN apt-get clean -y
RUN apt-get autoclean -y
RUN apt-get autoremove -y
RUN rm -rf /var/lib/apt/lists/*

# Enable all UTF-8 locales
RUN sed -i -E "s/#\ (.*)\.UTF-8(.*)/\1.UTF-8\2/" /etc/locale.gen && locale-gen
