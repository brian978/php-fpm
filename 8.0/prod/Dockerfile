FROM php:8.0.10-fpm

ARG DEBIAN_FRONTEND=noninteractive

# Prequisites
RUN apt-get update && apt-get install -y apt-utils
RUN apt-get upgrade -y
RUN apt-get install -y gnupg curl apt-transport-https vim unixodbc unixodbc-dev

# Add NodeJS repository
RUN curl -sL https://deb.nodesource.com/setup_16.x | bash -

# Add Yarn repository
RUN curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add -
RUN echo "deb https://dl.yarnpkg.com/debian/ stable main" | tee /etc/apt/sources.list.d/yarn.list

# Download PHP tools
RUN curl https://getcomposer.org/composer-stable.phar -o /usr/local/bin/composer && chmod +x /usr/local/bin/composer
RUN curl https://phar.phpunit.de/phpunit-9.6.9.phar -o /usr/local/bin/phpunit && chmod +x /usr/local/bin/phpunit

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

# PHP setup MSSQL
RUN pecl install sqlsrv && docker-php-ext-enable sqlsrv && pecl install pdo_sqlsrv && docker-php-ext-enable pdo_sqlsrv

# PHP AMQP
RUN pecl install amqp && docker-php-ext-enable amqp

# PHP developer tools
RUN pecl install xdebug && docker-php-ext-enable xdebug

# PHP setup extensions
RUN docker-php-ext-configure gd --with-freetype --with-jpeg && docker-php-ext-install -j$(nproc) gd \
    && docker-php-ext-configure imap --with-kerberos --with-imap-ssl && docker-php-ext-install -j$(nproc) imap \
    && docker-php-ext-configure intl && docker-php-ext-install -j$(nproc) intl \
    && docker-php-ext-configure ldap && docker-php-ext-install ldap

RUN docker-php-ext-install -j$(nproc) \
        bcmath \
        bz2 \
        calendar \
        ctype \
        curl \
        fileinfo \
        ftp \
        gettext \
        iconv \
        intl \
        mbstring \
        mysqli \
        pdo_mysql \
        pdo_pgsql \
        pdo_sqlite \
        phar \
        pgsql \
        soap \
        sockets \
        sodium \
        xml \
        xmlwriter \
        xsl \
        zip \
    && pecl install mongodb && docker-php-ext-enable mongodb \
    && pecl install memcached && docker-php-ext-enable memcached \
    && pecl install redis && docker-php-ext-enable redis \
    && yes '' | pecl install imagick && docker-php-ext-enable imagick \
    && docker-php-source delete \
    && apt-get clean -y && apt-get autoclean -y && apt-get autoremove -y \
    && rm -rf /var/lib/apt/lists/*

# Enable all UTF-8 locales
RUN sed -i -E "s/#\ (.*)\.UTF-8(.*)/\1.UTF-8\2/" /etc/locale.gen && locale-gen
